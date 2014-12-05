class Netease::Monitoring < ActiveRecord::Base
  belongs_to :user

  serialize :options, Hash

  SOURCES = ['环球网', '新华网', '人民网']
  SOURCE_PATTERNS = {
      '环球网' => /环球(网|时报)/,
      '新华网' => /新华网/,
      '人民网' => /人民(网|日报)/
  }

  before_validation :format_keyword
  validates :keyword, presence: true, length: {maximum: 20, minimum: 2}, uniqueness: {scope: :user_id}
  validate :options_check

  validate on: :create do
    errors.add(:base, :too_many, limit:10) if Netease::Monitoring.where(user_id: self.user_id).count >= 10
  end

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
    return false unless title.downcase.include? self.keyword.downcase
    !self.matches_source?(news['source'])
  end

  def matches_source? (source)
    return false unless self.options[:filtered_sources].present?
    self.options[:filtered_sources].each do |s|
      pattern = SOURCE_PATTERNS[s]
      next if pattern.nil?
      return true if source =~ pattern
    end
    false
  end

private
  def options_check
    return if options.nil?
    if options[:filtered_sources].present?
      sources = options[:filtered_sources]
      return errors.add(:options, "#{sources} is not a valid source") unless sources.is_a? Array
      sources.each do |s|
        errors.add(:options, "#{s} is not a valid source") unless SOURCES.include? s
      end
    end
  end

  def format_keyword
    self.keyword.gsub!(/[\u{1F600}-\u{1F6FF}]/,'')
    self.keyword = self.keyword.strip.gsub(/\s+/, ' ').downcase
  end
end
