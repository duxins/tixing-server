module APIv1
  class Notifications < Grape::API
    namespace :notifications do

      before do
        authenticate!
      end

      desc "List authenticated user's notifications"

      get '/' do
        notifications = current_user.notifications

        pagination = {}

        notifications =  notifications.page(params[:page]).per(25).tap do |data|
            pagination[:total_pages]  = data.num_pages
            pagination[:next_page]    = data.next_page || 0
            pagination[:prev_page]    = data.prev_page || 0
        end

        present :data, notifications, with: APIv1::Entities::Notification
        present :pagination, pagination, with: APIv1::Entities::Pagination
      end

      desc 'Retrieve a single notification'

      get '/:id' do
        notification = current_user.notifications.find(params[:id])
        present notification, with: APIv1::Entities::Notification
      end

      desc 'Delete a notification'
      delete '/:id' do
        status 204
        current_user.notifications.delete(params[:id])
      end

    end
  end
end