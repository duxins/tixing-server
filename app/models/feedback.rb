class Feedback < ActiveRecord::Base
  belongs_to :user

  validates :content, presence: true, length: { maximum: 1000 }

end
