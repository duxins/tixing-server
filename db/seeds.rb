# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env == 'development'
  # Demo User
  user = User.find_or_initialize_by(name: 'demo')
  if user.new_record?
    user.name = 'demo'
    user.password = '1234'
    user.auth_token = '1234'
    user.save!
  end

  # Rpush APP
  app = Rpush::Apns::App.find_or_initialize_by(name: 'ios')
  app.id = 1
  app.certificate = File.read("#{Rails.root}/config/apn_certificate.pem")
  app.environment = 'sandbox'
  app.connections = 1
  app.save!
end

