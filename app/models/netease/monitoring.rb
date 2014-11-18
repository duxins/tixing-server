class Netease::Monitoring < ActiveRecord::Base
  belongs_to :user

  before_validation :format_keyword
  validates :keyword, presence: true, length: {maximum: 20, minimum: 2}, uniqueness: {scope: :user_id}

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
