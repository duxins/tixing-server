class Feedback < ActiveRecord::Base
  belongs_to :user

  validates :content, presence: true, length: { maximum: 1000 }
  after_create :send_notification_email

private
  def send_notification_email
    FeedbackMailer.delay.notification_email(self) if Rails.env.production?
  end
end
