module Tixing
  class Users < Grape::API

    desc "Retrieve the authenticated user's profile"
    get '/user' do
      authenticate!
      present current_user, with: Tixing::Entities::User, type: 'full'
    end

    desc 'Login'
    params do
      requires :name, type:String
      requires :password, type:String
    end
    post '/login' do
      user = User.find_by_name(params[:name])
      if user && user.authenticate(params[:password])
        present user, with: Tixing::Entities::User, type: 'full'
      else
        error!({error:'Incorrect username or password.', code:1000}, 400)
      end
    end

    desc 'Set default alert sound for the authenticated user.'
    params do
      requires :sound, type:String
    end

    put '/user/sound' do
      status 204
      authenticate!
      current_user.update(sound: params[:sound])
    end


    desc 'Silence push notification at night'
    put '/user/silence_at_night' do
      status 204
      authenticate!
      current_user.update(silent_at_night: true)
    end

    delete '/user/silence_at_night' do
      status 204
      authenticate!
      current_user.update(silent_at_night: false)
    end

  end
end