module Tixing
  class Devices < Grape::API
    namespace :devices do
      before do
        authenticate!
      end

      desc 'Update device token or create a new record.'
      params do
        requires :name,  type:String
        requires :token, type:String
        requires :timezone, type:Integer
      end
      put '/' do
        status 204
        device = current_user.devices.find_or_initialize_by(token: params[:token])
        if device.new_record?
          device.name = params[:name]
          device.save
        else
          device.timezone = params[:timezone]
          device.save
        end
      end

      desc 'Revoke device token'
      params do
        requires :token, type:String
      end
      delete '/' do
        status 204
        current_user.devices.where(token: params[:token]).destroy_all
      end


      desc "List the authenticated user's devices"
      get '/' do
        present current_user.devices, with:Tixing::Entities::Device
      end

    end
  end
end