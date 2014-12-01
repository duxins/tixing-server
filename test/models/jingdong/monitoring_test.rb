require 'test_helper'

class Jingdong::MonitoringTest < ActiveSupport::TestCase
  test 'should not exceed products limit (10)' do
    I18n.locale = :en
    10.times do
      assert Jingdong::Monitoring.new(user_id:2, threshold: 1).save
    end
    monitoring =  Jingdong::Monitoring.create(user_id:2, threshold: 1)
    assert_not monitoring.id
    error_message = I18n.t('activerecord.errors.models.jingdong/monitoring.attributes.base.too_many', limit: 10)
    assert_not error_message.match(/^translation missing/)
    assert_equal error_message, monitoring.errors.full_messages.first
  end

  test 'should not save with invalid threshold' do
    assert Jingdong::Monitoring.new(threshold: 1).save
    assert_not Jingdong::Monitoring.new(threshold: -1).save
    assert_not Jingdong::Monitoring.new(threshold: 0).save
  end
end
