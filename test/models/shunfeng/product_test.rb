require 'test_helper'

class Shunfeng::ProductTest < ActiveSupport::TestCase
  def setup
  end

  test 'should fetch product correctly' do
    #http://www.sfbest.com/html/products/13/1500012174.html
    VCR.use_cassette('shunfeng_comvita_1500012174') do
      product = Shunfeng::Product.fetch(1500012174)
      assert_equal 1500012174, product.id
      assert_equal 12174, product.sku
      assert_equal 89, product.price
      assert_match '康维他comvita 多花种蜂蜜 500g', product.name
    end
  end

  test 'should fetch correct price' do
    VCR.use_cassette('shunfeng_chicken_leg_1800024143') do
      product = Shunfeng::Product.fetch(1800024143)
      assert_equal 39.8, product.price
    end

    #http://www.sfbest.com/html/products/9/1800008669.html
    #金卡以上会员
    VCR.use_cassette('shunfeng_1800008669') do
      product = Shunfeng::Product.fetch(1800008669)
      assert_equal 39.8, product.price
    end

    VCR.use_cassette'shunfeng_beef_1800018756' do
      product = Shunfeng::Product.fetch(1800018756)
      assert_equal 109, product.price
    end

    #TODO: 钻石卡
  end

  test 'should return proper thumb URL' do
    assert_equal 'http://p02.sfbest.com/2013/1500012174/thumb_1500012174_1_1.jpg', shunfeng_products(:shrimp).thumb
    assert_not shunfeng_products(:vc).thumb
  end

  test 'should return nil when there is a network problem' do
    stub_request(:any, /sfbest.com/).to_timeout
    product = Shunfeng::Product.fetch(1800030969)
    assert_not product
  end

  test 'should not save with invalid price' do
    assert Shunfeng::Product.create(id: 1, price: 0).errors[:price]
    assert Shunfeng::Product.create(id: 2, price: -1).errors[:price]
    assert Shunfeng::Product.create(id: 2).errors[:price]
  end

  test 'should return correct product URL' do
    assert_equal shunfeng_products(:beef).url, 'http://www.sfbest.com/html/products/19/1800018775.html'
    assert_equal shunfeng_products(:vc).url, 'http://www.sfbest.com/html/products/3/1200002309.html'
    assert_equal shunfeng_products(:shrimp).url, 'http://www.sfbest.com/html/products/34/1800033005.html'
  end
end
