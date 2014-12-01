require 'test_helper'

class Jingdong::ProductTest < ActiveSupport::TestCase
  def setup
    @product = jingdong_products(:iphone)
  end

  test 'should return absolute URL to product image' do
    assert_match %r[^http://], @product.image
  end

  test 'should fetch product correctly' do
    VCR.use_cassette('jingdong_product_iphone_1023438') do
      product = Jingdong::Product.fetch(1023438)
      assert_equal 1023438, product.id
      assert_match '苹果（APPLE）iPhone 5s 16G版 4G手机（深空灰色）TD-LTE/TD-SCDMA/GSM', product.name
      assert_equal 4188, product.price
    end
  end

  test 'should fetch correct price' do
    VCR.use_cassette('jingdong_price_iphone_1023437') do
      assert_equal 4188, Jingdong::Product.fetch_price(1023437)
    end
  end

  test 'should return nil when there is a network problem' do
    stub_request(:any, /jd.com/).to_timeout
    product = Jingdong::Product.fetch(1023438)
    assert_not product
  end

  test 'should return cached product when there is a network problem' do
    stub_request(:any, /jd.com/).to_timeout
    product = Jingdong::Product.fetch(@product.id)
    assert @product.id, product.id
  end
end
