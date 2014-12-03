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

  test 'should return correct URL' do
    assert_equal shunfeng_products(:beef).url, 'http://www.sfbest.com/html/products/19/1800018775.html'
    assert_equal shunfeng_products(:vc).url, 'http://www.sfbest.com/html/products/3/1200002309.html'
    assert_equal shunfeng_products(:shrimp).url, 'http://www.sfbest.com/html/products/34/1800033005.html'
  end
end
