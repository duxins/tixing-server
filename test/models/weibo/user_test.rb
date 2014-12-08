require 'test_helper'

class Weibo::UserTest < ActiveSupport::TestCase
  def setup
    @freeze_time = DateTime.new(2014, 12, 5, 8, 56, 0 ,'+8')
  end

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

  test 'should fetch feeds' do
    Timecop.freeze(@freeze_time) do
      VCR.use_cassette('weibo_sina_finance_feeds') do
        user = Weibo::User.create(uid: 1638782947, name: '新浪财经')
        feeds = user.fetch_feeds
        assert_equal 1, feeds.count
        user.reload
        assert_equal 3784341387718007, user.last_weibo_id.to_i
        feeds = user.fetch_feeds
        assert_equal 0, feeds.count
      end
    end
  end

  test 'scope' do
    #important: priority: :high or followers_count between 1 and 10000
    #less-important: followers_count between 1 and 10 and priority != :high
    Weibo::User.create(uid: 1, priority: :high, followers_count: 1)
    Weibo::User.create(uid: 2, priority: :low,  followers_count: 10000)
    Weibo::User.create(uid: 3, priority: :medium,  followers_count: 1000)

    Weibo::User.create(uid: 4, priority: :low,  followers_count: 9)
    assert_equal 3, Weibo::User.important.count
    assert_equal 1, Weibo::User.less_important.count
    assert_equal 4, Weibo::User.less_important.first.uid
  end
end
