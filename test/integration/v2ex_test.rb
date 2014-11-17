require 'test_helper'
require 'webmock/minitest'

class V2exTest < ActiveSupport::TestCase

  test 'should return recent topics' do
    Settings['v2ex.last_topic_id'] = 0

    VCR.use_cassette('v2ex_recent_topics') do
      @topics = V2ex.recent
      assert_not_empty @topics
      @topics.each {|topic| assert topic.has_key?('id')}
      assert_equal 147172, V2ex.last_topic_id
    end

    Settings['v2ex.last_topic_id'] = 147168
    VCR.use_cassette('v2ex_recent_topics') do
      @topics = V2ex.recent
      assert_not_empty @topics
      assert_equal 2, @topics.count

      @topics = V2ex.recent
      assert_empty @topics
    end

  end

  test 'should return empty array when error occurs' do
    stub_request(:any, /v2ex.com/).to_timeout
    @topics = V2ex.recent
    assert_empty @topics
  end

end