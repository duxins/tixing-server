class UserMailer < ActionMailer::Base
  default from: ENV['mailer_user_name']

  def new_user_email(user)
    @user = user
    mail(to: ENV['admin_email'], subject: "[消息提醒 - 新用户] ##{@user.id} #{@user.name}")
  end
end
