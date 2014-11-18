# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


service_list = [
  {
    id: Weibo::SERVICE_ID,  #1
    name: '新浪微博',
    icon: 'weibo.png',
    url: '/service/weibo',
    description: '',
  },
  {
    id: V2ex::SERVICE_ID,    #2
    name: 'V2EX',
    icon: 'v2ex.png',
    url: '/service/v2ex',
    description: '',
  },
  {
    id: Netease::SERVICE_ID,  #3
    name: '网易新闻',
    icon: 'netease.png',
    url: '/service/netease',
    description: '',
  }
];

service_list.each do |service|
  s = Service.find_or_create_by!(id: service[:id])
  s.id    =  service[:id]
  s.name  =  service[:name]
  s.icon  =  service[:icon]
  s.url   =  service[:url]
  s.save!
end

# Demo user
if Rails.env == 'development'
  user = User.find_or_initialize_by(name: 'demo')
  if user.new_record?
    user.name = 'demo'
    user.password = '1234'
    user.auth_token = '1234'
    user.save!
  end
end

# Rpush APP
app = Rpush::Apns::App.find_or_initialize_by(name: 'ios')
app.id = 1
app.certificate = File.read("#{Rails.root}/config/apn_certificate.pem")

if Rails.env == 'development'
  app.environment = 'sandbox'
  app.connections = 1
else
  app.environment = 'production'
  app.connections = 5
end
app.save!

