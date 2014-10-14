class User < ActiveRecord::Base
  has_secure_password
  acts_as_paranoid

  has_many :devices
  has_many :notifications

  before_validation :downcase_email
  before_create :generate_token

  validates :email, presence: true, uniqueness: true

private

  def downcase_email
    self.email = self.email.strip.downcase
  end

  def generate_token
    begin
      self[:auth_token] = SecureRandom.hex(20)
    end while User.exists?(auth_token: self[:auth_token])
  end

end
