class Service < ActiveRecord::Base
  has_many :installations
  has_many :users, through: :installations
  default_scope {order(position: :desc, id: :asc)}
end
