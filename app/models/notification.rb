class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :service
  default_scope {order('id DESC')}
end
