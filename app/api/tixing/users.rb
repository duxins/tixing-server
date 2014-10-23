module Tixing
  class Users < Grape::API

    desc "Retrieve the authenticated user's profile"
    get '/user' do
      authenticate!
      present current_user, with: Tixing::Entities::User, type: 'full'
    end

    desc 'Login'
    params do
      requires :email, type:String
      requires :password, type:String
    end
    post '/login' do
      user = User.find_by_email(params[:email])
      if user && user.authenticate(params[:password])
        present user, with: Tixing::Entities::User, type: 'full'
      else
        error!({error:'Incorrect email or password.', code:1000}, 400)
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

  end
end