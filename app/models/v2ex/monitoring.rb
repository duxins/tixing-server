class V2ex::Monitoring < ActiveRecord::Base
  belongs_to :user
  before_validation :format_keyword

  validates :keyword, presence: true, length: { maximum: 20, minimum: 2 }

private
  def format_keyword
    self.keyword.strip!
  end
end
