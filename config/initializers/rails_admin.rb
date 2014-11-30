RailsAdmin.config do |config|

  config.main_app_name = ["消息提醒", "Control Panel"]

  config.authorize_with do |controller|
    redirect_to main_app.root_path unless admin?
  end

  config.included_models = [
      'User',
      'Device',
      'Notification',
      'Service',
      'Weibo::User',
      'Weibo::Follower',
      'V2ex::Monitoring',
      'Netease::Monitoring',
  ]

  config.actions do
    dashboard
    index
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
  end
end
