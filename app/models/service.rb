class Service < ActiveRecord::Base
  has_many :installations
  has_many :users, through: :installations
end
