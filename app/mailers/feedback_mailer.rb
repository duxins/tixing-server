class FeedbackMailer < ActionMailer::Base
  default from: ENV['mailer_user_name']

  def notification_email(feedback)
    @feedback = feedback
    @user = @feedback.user
    mail(to: ENV['admin_email'], subject: "[消息提醒 - 反馈] ##{@feedback.id} #{@feedback.content[0..20]}")
  end
end
