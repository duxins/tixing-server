require 'test_helper'

class Jingdong::PriceTest < ActiveSupport::TestCase
  test 'should not save with invalid price' do
    assert Jingdong::Price.new(price:1).save
    assert_not Jingdong::Price.new(price:0).save
    assert_not Jingdong::Price.new(price:-1.0).save
    assert_not Jingdong::Price.new(price:-10000000).save
  end
end
