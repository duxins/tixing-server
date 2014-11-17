require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  def setup
    @valid_token = 'a' * 64
    @device = Device.create(token: @valid_token)
  end

  test 'should not save with invalid token' do
    token = SecureRandom.hex(32)

    assert_not Device.new().save
    assert_not Device.new(token: 123).save
    assert_not Device.new(token: "#{token[0..62]}").save
    assert_not Device.new(token: "#{'a' * 63}").save
    assert_not Device.new(token: "#{'<' * 64}").save
  end

  test 'should have default timezone' do
    assert_equal 8, @device.timezone
  end

  test 'at_night? should return true during the night' do
    @device.timezone = 8
    time = DateTime.new(2014, 12, 1, 0, 0, 0 ,'+8')

    # 22:00
    Timecop.freeze(time.change(hour:22)) do
      assert_equal true, @device.at_night?
    end

    # 1:00
    Timecop.freeze(time.change(hour:1)) do
      assert_equal true, @device.at_night?
    end

    # 7:59
    Timecop.freeze(time.change(hour:7, min:59)) do
      assert_equal true, @device.at_night?
    end
  end

  test 'at_night? should return false during the day' do
    @device.timezone = 8
    time = DateTime.new(2014, 12, 1, 0, 0, 0, '+8')

    # 8:00
    Timecop.freeze(time.change(hour: 8)) do
      assert_equal false, @device.at_night?
    end

    # 21:59
    Timecop.freeze(time.change(hour: 21, min: 59)) do
      assert_equal false, @device.at_night?
    end
  end

  test 'at_night? should return correctly in different time zones' do
    time = DateTime.new(2014, 12, 1, 0, 0, 0, '+8')

    # 8:00
    Timecop.freeze(time.change(hour: 8)) do
      @device.timezone = 9
      assert_equal false, @device.at_night?

      @device.timezone = -5
      assert_equal false, @device.at_night?
    end

    Timecop.freeze(time.change(hour: 6)) do
      @device.timezone = 9
      assert_equal true, @device.at_night?
    end

    Timecop.freeze(time.change(hour: 21)) do
      @device.timezone = 9
      assert_equal true, @device.at_night?
    end

  end

end
