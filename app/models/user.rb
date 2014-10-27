class User < ActiveRecord::Base
  has_secure_password
  acts_as_paranoid

  has_many :devices
  has_many :notifications, dependent: :destroy
  has_many :installations
  has_many :services, -> { order 'installations.id ASC' }, through: :installations

  before_create :generate_token

  validates :name, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[a-z0-9]{4,15}\Z/i}, if: :name_changed?

private

  def generate_token
    begin
      self[:auth_token] = SecureRandom.hex(20)
    end while User.exists?(auth_token: self[:auth_token])
  end

end
