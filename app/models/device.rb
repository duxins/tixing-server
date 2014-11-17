class Device < ActiveRecord::Base
  belongs_to :user

  validates :token, format: { with: /\A[0-9a-z]{64}\z/i}
  validates :timezone, inclusion: { in: -14..14 }

  def at_night?
    now = DateTime.now.in_time_zone(self.timezone)
    now.hour < 8 or now.hour >= 22
  end
end
