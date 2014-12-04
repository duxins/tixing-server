require 'test_helper'

class Weibo::UserTest < ActiveSupport::TestCase
  test 'should fetch weibo user correctly' do
    VCR.use_cassette('weibo_sina_finance') do
      user = Weibo::User.fetch_weibo_user('新浪财经')
      assert_equal 1638782947, user.uid
      assert_equal '新浪财经', user.name
      assert_equal 'http://tp4.sinaimg.cn/1638782947/180/5710057679/1', user.avatar
    end
  end

  test 'should have correct url attribute' do
    user = Weibo::User.create(uid: 12345)
    assert_equal 'http://weibo.com/u/12345', user.url
  end

  test "should raise NotFound exception when user doesn't exist" do
    VCR.use_cassette('weibo_sina_non_existent_user') do
      assert_raise Weibo::User::NotFound do
        Weibo::User.fetch_weibo_user('non-existent-user')
      end
    end
  end

  test 'should raise APIError error exception when there is a network problem' do
    stub_request(:get, /localhost/).to_timeout
    assert_raise Weibo::User::APIError do
      Weibo::User.fetch_weibo_user('新浪娱乐')
    end
  end

  test 'should return cached user' do
    VCR.use_cassette('weibo_sina_finance') do
      user = Weibo::User.fetch_weibo_user('新浪财经')
      assert_equal 1638782947, user.uid
    end

    stub_request(:get, /localhost/).to_timeout
    user = Weibo::User.fetch_weibo_user('新浪财经')
    assert_equal 1638782947, user.uid
  end

end
