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
        list.concat(self.fetch_news_list(v))
      end

      list
    end

    def fetch_news_list(cid)
      url = "http://c.3g.163.com/nc/article/list/#{cid}/0-20.html"

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

        collection.select! do |news|
          time_diff = DateTime.now.to_i - DateTime.parse(news['ptime'] + "+8").to_i
          next if Rails.cache.read(self.cache_key news['docid'])
          Rails.logger.info "[NETEASE] Fetched News: #{news['title']}|#{news['docid']}|#{news['ptime']}|#{time_diff}"
          time_diff < 3600 and news['url'].present?
        end

        collection.map! do |news|
          Rails.cache.write(self.cache_key(news['docid']), true, expires_in: 2.hour)

          news['published_at'] = DateTime.parse(news['ptime'] + "+8")
          news['url'] = news['url_3w']
          news['img'] = news['imgsrc']

          # 过滤新闻专题
          news.select {|k, v| %w[docid title digest published_at url img].include? k }
        end

        collection
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
