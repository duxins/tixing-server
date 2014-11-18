require 'test_helper'

class Netease::NeteaseTest < ActiveSupport::TestCase
  def setup
    @freeze_time = DateTime.new(2014, 11, 18, 17, 50, 0 ,'+8')
    @news_count_high = 4
    @news_count_medium = 2
  end

  test 'service_id should equal 3' do
    assert_equal 3, Netease::SERVICE_ID
  end

  test 'categories should have two priorities' do
    assert Netease::CATEGORIES.has_key? :high
    assert Netease::CATEGORIES.has_key? :medium
  end

  test 'should return recent news' do
    Rails.cache.clear

    Timecop.freeze(@freeze_time) do
      VCR.use_cassette('netease_recent_news_high') do
        news = Netease.recent(priority: :high)
        assert_equal @news_count_high, news.count

        news.each do |item|
          assert item.has_key?('title')
          assert item.has_key?('digest')
          assert item.has_key?('url')
          assert item.has_key?('img')
          assert item.has_key?('published_at') and item['published_at'].is_a? DateTime
        end
      end

      VCR.use_cassette('netease_recent_news_medium') do
        news = Netease.recent(priority: :medium)
        assert_equal @news_count_medium, news.count
      end
    end

  end

  test 'should return empty array when error occurs' do
    stub_request(:any, /163.com/).to_timeout
    assert_empty Netease.recent
  end

  test 'should skip captured news' do
    Rails.cache.clear
    Timecop.freeze(@freeze_time) do
      VCR.use_cassette('netease_recent_news_high') do
        news = Netease.recent(priority: :high)
        assert_equal @news_count_high, news.count
      end

      VCR.use_cassette('netease_recent_news_high') do
        news = Netease.recent(priority: :high)
        assert_equal 0, news.count
      end
    end
  end

end