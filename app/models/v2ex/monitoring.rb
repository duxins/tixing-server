class V2ex::Monitoring < ActiveRecord::Base
  belongs_to :user
  before_validation :format_keyword

  validates :keyword, presence: true, length: { maximum: 20, minimum: 2 }

private
  def format_keyword
    self.keyword.gsub!(/[\u{1F600}-\u{1F6FF}]/,'')
    self.keyword = self.keyword.strip.gsub(/\s+/, ' ').downcase
  end
end
