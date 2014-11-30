module APIv1
  class Users < Grape::API

    desc "Retrieve the authenticated user's profile"
    get '/user' do
      authenticate!
      present current_user, with: APIv1::Entities::User, type: 'full'
    end

    desc 'Login'
    params do
      requires :name, type:String
      requires :password, type:String
    end
    post '/login' do
      user = User.find_by_name(params[:name])
      if user && user.authenticate(params[:password])
        present user, with: APIv1::Entities::User, type: 'full'
      else
        error!({error:I18n.t(:incorrect_password), code:1001}, 400)
      end
    end

    desc 'Signup'
    params do
      requires :name, type: String
      requires :password, type: String
    end

    post '/signup' do
      user = User.create(name: params[:name], password: params[:password])
      if user.errors.any?
        error!({error:user.errors.full_messages.join(' '), code:1002}, 400)
      else
        thumb =  request.base_url + "/icons/tixing.png"
        Notification.create(message: '欢迎使用消息提醒', title:'消息提醒', thumb: thumb, user: user)
        present user, with: APIv1::Entities::User, type: 'full'
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