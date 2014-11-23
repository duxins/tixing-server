class User < ActiveRecord::Base
  has_secure_password
  acts_as_paranoid

  has_many :devices
  has_many :notifications, dependent: :destroy
  has_many :installations
  has_many :feedbacks
  has_many :services, -> { select('services.*, installations.enabled as enabled, installations.preferences as preferences').order 'installations.id ASC' }, through: :installations

  default_scope { where(disabled: false) }
  before_create :generate_token

  validates :name, presence: true, uniqueness: { case_sensitive: false, if: :name_changed? }, format: { with: /\A[a-z0-9]{4,15}\Z/i}

private

  def generate_token
    begin
      self[:auth_token] = SecureRandom.hex(20)
    end while User.exists?(auth_token: self[:auth_token])
  end

end
