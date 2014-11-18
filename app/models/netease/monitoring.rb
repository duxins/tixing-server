class Netease::Monitoring < ActiveRecord::Base
  belongs_to :user

  before_validation :format_keyword
  validates :keyword, presence: true, length: {maximum: 20, minimum: 2}, uniqueness: {scope: :user_id}

  def self.check(options = {})
    priority = options[:priority] || :high
    recent_news = Netease.recent priority: priority

    return [] if recent_news.empty?

    matched = []

    recent_news.each_with_index do |news, index|
      matched[index] = {}
      matched[index][:users] = []
      matched[index][:news] = news
    end

    self.find_each(batch_size: 200) do |monitoring|
      recent_news.each_with_index do |news, index|
        if !matched[index][:users].include? monitoring.user_id and monitoring.matched? news
          matched[index][:users] << monitoring.user_id
        end
      end
    end

    matched.reject {|item| item[:users].count == 0}

  end

  def matched?(news)
    title = "#{news['title']}#{news['digest']}".downcase
    title.gsub!(/\s+/, ' ')
    title.downcase.include? self.keyword.downcase
  end

private
  def format_keyword
    self.keyword = self.keyword.strip.gsub(/\s+/, ' ').downcase
  end
end
