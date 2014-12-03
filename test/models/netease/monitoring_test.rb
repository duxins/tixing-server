require 'test_helper'

class Netease::MonitoringTest < ActiveSupport::TestCase
  def setup
    @freeze_time = DateTime.new(2014, 12, 3, 21, 0, 0 ,'+8')
  end

  test 'should return recent news along with the subscribers' do
    Timecop.freeze(@freeze_time) do
      Rails.cache.clear

      Netease::Monitoring.create(user_id: 2, keyword: '警察')
      Netease::Monitoring.create(user_id: 3, keyword: '报警')

      VCR.use_cassette('netease_recent_news_high') do
        news =  Netease::Monitoring.check(priority: :high)
        assert_equal 2, news.first[:users].count # => user 2,3
        assert_equal 1, news.count
        assert_equal '逃犯亲戚问宽容政策致其曝光', news.first[:news]['title']
      end

      Netease::Monitoring.delete_all

      Rails.cache.clear
      Netease::Monitoring.create(user_id: 2, keyword: '报警')
      Netease::Monitoring.create(user_id: 2, keyword: '占中')

      VCR.use_cassette('netease_recent_news_high') do
        news =  Netease::Monitoring.check(priority: :high)
        assert_equal 2, news.count
      end

    end
  end

  test 'should match' do
    news = {
        'title' => '习近平将走遍澳大利亚所有州 幽默要证书',
        'digest' => '中国国家主席习近平在堪培拉会见澳大利亚总督科斯格罗夫'
    }

    assert_not create_monitoring('包子').matched?(news)
    assert_not create_monitoring('习 近平').matched?(news)

    assert create_monitoring('习近平').matched?(news)
    assert create_monitoring('堪培拉').matched?(news)

    news = {
        'title' => '苹果推出iOS 8.1.1升级包 改善旧设备体验',
        'digest' => '11月18日消息，苹果公司已对上个月针对iPhone、iPad和iPod  Touch发布的iOS 8.1操作系统正式推出了iOS 8.1.1升级补丁'
    }

    assert create_monitoring('ios').matched?(news)
    assert create_monitoring('iphone').matched?(news)
    assert create_monitoring('IPAD').matched?(news)
    assert create_monitoring('iPod Touch').matched?(news)

  end

  test 'should format keyword properly' do
    assert_equal '关键词', create_monitoring('关键词').keyword
    assert_equal '关键词', create_monitoring('   关键词   ').keyword
    assert_equal '关 键 词', create_monitoring('关    键  词').keyword
    assert_equal 'keyword', create_monitoring('Keyword').keyword
    # 删除 emoji 字符
    # http://stackoverflow.com/a/24674266/575163
    assert_equal '关键词', create_monitoring("关键词\u{1F600}").keyword
  end

  test 'should not save with invalid keyword' do
    assert_not Netease::Monitoring.new(keyword: '').save
    assert_not Netease::Monitoring.new(keyword: 'a').save
    assert_not Netease::Monitoring.new(keyword: '啊').save
    assert_not Netease::Monitoring.new(keyword: ' a ').save
  end

  test 'should not create more than 10 rules' do
    10.times do |i|
      assert Netease::Monitoring.new(keyword:"keyword-#{i}", user_id: 2).save
    end
    assert_not Netease::Monitoring.new(keyword:"keyword-11", user_id: 2).save
    # should not validate on update
    assert Netease::Monitoring.where(user_id: 2).first.update(keyword: 'keyword-11')
  end

  test 'should not save when keyword exists' do
    Netease::Monitoring.create(user_id: 1, keyword: '关键词')

    assert_not Netease::Monitoring.new(user_id: 1, keyword: '关键词').save
    assert Netease::Monitoring.new(user_id:2, keyword: '关键词').save
  end

private
  def create_monitoring(keyword)
    Netease::Monitoring.create(keyword: keyword)
  end
end
