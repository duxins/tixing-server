# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


service_list = [
    {
        id: Weibo::SERVICE_ID,
        name: '新浪微博',
        icon: 'weibo.png',
        url: '/service/weibo',
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

if Rails.env == 'development'
  user = User.find_or_initialize_by(name: 'demo')
  if user.new_record?
    user.name = 'demo'
    user.password = '1234'
    user.auth_token = '1234'
    user.save!
  end
end

