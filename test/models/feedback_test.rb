require 'test_helper'

class FeedbackTest < ActiveSupport::TestCase
  test 'should save emoji characters' do
    emoji = "😄"
    feedback = Feedback.create!(content: emoji)
    assert_equal emoji, feedback.content
  end

  test 'should not exceed 1000 characters' do
    content = 'x' * 1000
    assert Feedback.new(content: content).save

    content = 'x' * 1001
    assert_not Feedback.new(content: content).save
  end
end
