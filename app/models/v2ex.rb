module V2ex
  SERVICE_ID = 2
  def self.table_name_prefix
    'v2ex_'
  end

  def self.recent
    begin
      url = 'https://www.v2ex.com/api/topics/latest.json'
      c = Curl::Easy.perform(url) do |curl|
        curl.headers['User-Agent'] = 'tixing'
        curl.connect_timeout = 5
      end
      topics = JSON.parse(c.body_str)
      since = self.last_topic_id
      topics.select!{ |topic| topic['id'].to_i > since }
      self.last_topic_id = topics.first['id'].to_i unless topics.empty?
      topics
    rescue => e
      Rails.logger.error("V2EX API ERROR :#{e.message}")
      return []
    end
  end

  def self.last_topic_id
    Settings['v2ex.last_topic_id'].to_i
  end

  def self.last_topic_id=(id)
    Settings['v2ex.last_topic_id'] = id
  end
end
