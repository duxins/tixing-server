class V2ex::Monitoring < ActiveRecord::Base
  belongs_to :user
  before_validation :format_keyword

  validates :keyword, presence: true, length: { maximum: 20, minimum: 2 }

  def self.fetch_recent_topics
    begin
      url = 'https://www.v2ex.com/api/topics/latest.json'
      c = Curl::Easy.perform(url) do |curl|
        curl.headers['User-Agent'] = 'tixing'
        curl.connect_timeout = 5
      end
      topics = JSON.parse(c.body_str)

      last_topic_id = Settings['v2ex.last_topic_id'].to_i
      topics.select! {|topic| topic['id'].to_i > last_topic_id }

      Settings['v2ex.last_topic_id'] = topics.first['id'].to_i unless topics.empty?
      topics
    rescue => e
      Rails.logger.error("V2EX API ERROR :#{e.message}")
      return []
    end
  end

private
  def format_keyword
    self.keyword.strip!
  end
end
