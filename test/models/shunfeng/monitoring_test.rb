require 'test_helper'

class Shunfeng::MonitoringTest < ActiveSupport::TestCase
  def setup
  end

  test 'should not save with invalid threshold' do
    assert Shunfeng::Monitoring.new(threshold: 1).save
    assert_not Shunfeng::Monitoring.new(threshold: nil).save
    assert_not Shunfeng::Monitoring.new(threshold: 0).save
    assert_not Shunfeng::Monitoring.new(threshold: -1).save
  end
end
