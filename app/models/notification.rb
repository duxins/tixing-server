class Notification < ActiveRecord::Base
  belongs_to :user
  default_scope {order('id DESC')}
end
