module Netease

  SERVICE_ID = 3

  CATEGORIES = {
    high: {
      '头条' => 'T1348647853363',
      '娱乐' => 'T1348648517839',
      '体育' => 'T1348649079062',
    },
    medium: {
      '财经' => 'T1348648756099',
      '科技' => 'T1348649580692',
    }
  }

  class << self

    def table_name_prefix
      'netease_'
    end

    def recent (options = {})
      priority = options[:priority] || :high
      list = []

      if priority == :all
        categories = CATEGORIES[:high].merge(CATEGORIES[:medium])
      else
        categories = CATEGORIES[priority]
      end

      categories.each do |k, v|
        list.concat(self.fetch_latest_news(v))
      end

      list
    end

    def fetch_latest_news(cid)
      url = "http://c.3g.163.com/nc/article/list/#{cid}/0-40.html"

      begin

        Rails.logger.info "[NETEASE] Started GET #{url}"

        c = Curl::Easy.perform(url) do |curl|
          curl.headers['User-Agent'] = 'tixing'
          curl.connect_timeout = 5
        end

        json = JSON.parse(c.body_str)

        raise "#{c.body_str[0..30]}" unless json.has_key?(cid)

        collection = json[cid]
        collection.sort_by! {|news|DateTime.parse(news['ptime'])}.reverse!

        latest_news = []

        collection.each do |news|
          next if Rails.cache.read(self.cache_key news['docid'])
          Rails.cache.write(self.cache_key(news['docid']), true, expires_in: 2.days)

          time_diff = DateTime.now.to_i - DateTime.parse(news['ptime'] + "+8").to_i
          Rails.logger.info "[NETEASE] Fetched News: #{news['title']}|#{news['docid']}|#{news['ptime']}|#{time_diff}"

          # 过滤专题新闻，或者一小时前发布的新闻
          next if time_diff > 7200 or news['url'].nil?

          news['published_at'] = DateTime.parse(news['ptime'] + "+8")
          news['url'] = news['url_3w']
          news['img'] = news['imgsrc']

          # 过滤无用字段
          news.select! {|k, v| %w[docid title digest published_at url img source].include? k }
          latest_news << news
        end

        Rails.logger.info "[NETEASE] Found #{latest_news.count} latest news" unless latest_news.empty?

        latest_news
      rescue => e
        Rails.logger.error("[NETEASE] API Error: #{url}, #{e.message}")
        []
      end
    end

    def cache_key (id)
      "netease:news:doc:#{id}"
    end

  end
end
