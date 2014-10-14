module Tixing
  class Devices < Grape::API
    namespace :devices do

      desc 'Update device token or create a new record.'
      params do
        requires :name,  type:String
        requires :token, type:String
      end
      put '/' do
        authenticate!
        status 204
        device = current_user.devices.find_or_initialize_by(token: params[:token])
        if device.new_record?
          device.name = params[:name]
          device.save!
        else
          device.touch
        end
      end


      desc "List the authenticated user's devices"
      get '/' do
        authenticate!
        present current_user.devices, with:Tixing::Entities::Device
      end

    end
  end
end