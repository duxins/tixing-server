class Jingdong::Product < ActiveRecord::Base
  has_many :prices, class_name: 'Jingdong::Price', dependent: :delete_all
  has_many :monitorings, :class_name => 'Jingdong::Monitoring', dependent: :delete_all
  scope :available, lambda { where('monitorings_count >?', 0).order('monitorings_count DESC') }

  def self.fetch(id)
    product = self.find_by_id(id)
    return product if product
    url = "http://item.jd.com/#{id}.html"
    Rails.logger.info("[JD] Request API: #{url}")
    begin
      c = Timeout::timeout(5) do
        Curl::Easy.perform(url) do |curl|
          curl.headers['User-Agent'] = 'tixing'
          curl.headers["Accept-Encoding"] = "gzip,deflate"
          curl.connect_timeout = 5
        end
      end

      html = c.body_str
      html = ActiveSupport::Gzip.decompress(html) if c.header_str =~ /Content-Encoding: gzip/

      html.force_encoding('gbk')
      html.encode!('utf-8')

      name = html.match(%r{<h1>([^<]*)</h1>}) {|m| m[1]}
      image = html.match(%r{src: '([^']*)'}) {|m| m[1]}
      price = self.fetch_price(id)

      self.create(id:id, name: name, price:price, image:image)
    rescue => e
      Rails.logger.error("[JD] #{e.message}")
      nil
    end
  end

  def self.fetch_price(id)
    url = "http://p.3.cn/prices/mgets?type=1&skuIds=J_#{id}"
    json = Timeout::timeout(5) do
      Curl::Easy.perform(url) do |curl|
        curl.headers['User-Agent'] = 'tixing'
      end.body_str
    end
    prices = JSON.parse(json)
    price = prices.first['p'].to_f
    raise 'invalid price' if price <= 0
    price
  end

  def url
    "openapp.jdmobile://virtual?params=" + URI.escape('{"category":"jump","des":"productDetail","skuId":"'+self.id.to_s+'","sourceType":"JSHOP_SOURCE_TYPE","sourceValue":"JSHOP_SOURCE_VALUE"}')
  end

  def web_url
    "http://m.jd.com/product/#{self.id}.html"
  end

  def image
    image = read_attribute(:image)
    return nil if image.nil?
    'http://img12.360buyimg.com/n7/' + image
  end
end
