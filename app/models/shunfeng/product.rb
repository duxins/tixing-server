class Shunfeng::Product < ActiveRecord::Base
  has_many :monitorings, class_name: 'Shunfeng::Monitoring', dependent: :delete_all
  scope :available, lambda { where('monitorings_count > ?', 0).order(monitorings_count: :desc) }
  validates :price, presence: true, numericality: {greater_than: 0}

  def self.fetch(id)
    product = self.find_by_id(id)
    return product if product
    url = self.url id
    Rails.logger.info("[SF] Request API: #{url}")
    begin
      c = Timeout::timeout(5) do
        Curl::Easy.perform(url) do |curl|
          curl.headers['User-Agent'] = 'tixing'
          curl.connect_timeout = 5
        end
      end
      html = c.body_str
      sku = html.match(/productId:(\d+),/) {|m| m[1]}
      raise "[id: #{id}] Sku not found: #{url}" if sku.nil?
      doc = Nokogiri::parse(html)
      name = doc.css('h1').text
      image = doc.css('#zoom-jpg img:first').attr('src')
      price = self.fetch_price(sku)
      self.create(id: id, name: name, image: image, price: price, sku: sku)
    rescue => e
      Rails.logger.error("[SF] #{e.message}")
      nil
    end
  end

  def self.fetch_price(sku)
    url = 'http://www.sfbest.com/goods/price/'
    json_str = Timeout::timeout(5) do
      curl = Curl::Easy.http_post(url, Curl::PostField.content('product_id', sku))
      curl.headers['User-Agent'] = 'tixing'
      curl.headers['X-Requested-With'] = 'XMLHttpRequest'
      curl.headers['Referer'] = 'http://www.sfbest.com/html/products/34/1800033005.html'
      curl.perform
      curl.body_str
    end
    json = JSON.parse(json_str)
    data = json['data']
    raise "[sku: #{sku}] invalid price #{json}" if data.nil? or data['price'].to_f <= 0
    data['price'].to_f
  end

  def self.url(id)
    path = (id.to_s[-5..-1].to_f / 1000).ceil
    "http://www.sfbest.com/html/products/#{path}/#{id}.html"
  end

  def thumb
    return nil unless self.image.present?
    self.image.gsub(/middle/, 'thumb')
  end

  def url
    Shunfeng::Product.url self.id
  end
end
