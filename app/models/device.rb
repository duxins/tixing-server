class Device < ActiveRecord::Base
  belongs_to :user

  validates :timezone, inclusion: { in: -14..14 }

  def at_night?
    now = DateTime.now.in_time_zone(self.timezone)
    !now.hour.between?(8, 22)
  end
end
