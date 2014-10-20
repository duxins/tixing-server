module Tixing
  class Notifications < Grape::API
    include Grape::Kaminari

    namespace :notifications do

      before do
        authenticate!
      end

      desc "List authenticated user's notifications"
      paginate

      get '/' do
        notifications = current_user.notifications
        present paginate(notifications), with: Tixing::Entities::Notification
      end

      desc 'Retrieve a single notification'

      get '/:id' do
        notification = current_user.notifications.find(params[:id])
        present notification, with: Tixing::Entities::Notification
      end

      desc 'Delete a notification'
      delete '/:id' do
        status 204
        current_user.notifications.delete(params[:id])
      end

    end
  end
end