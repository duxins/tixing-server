require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.create(name: 'test', password: '1234')
  end

  test 'should generate auth token properly' do
    assert_match /^[a-z0-9]{40}$/, @user.auth_token
  end

  test 'should not save without name or password' do
    assert_not User.new(name: '1234').save
    assert_not User.new(password: '1234').save
  end

  test 'should not save with invalid name' do
    user = { password: '1234' }

    user[:name] = '123'
    assert_not User.new(user).save

    user[:name] = 'demo-'
    assert_not User.new(user).save

  end

  test 'should not query for disabled user' do
    user = users(:demo)
    assert User.find_by_name(user.name)

    user.disabled = true
    user.save
    assert_not User.find_by_name(user.name)
  end

  test 'should not create if username exists' do
    user = User.new(name: 'test', password: 'password')
    assert_not user.save

    user = User.new(name: 'TEst', password: 'password')
    assert_not user.save
  end

  test 'should not update if username exists' do
    @user.name = 'demo'
    assert_not @user.save
  end

  test 'should perform case-insensitive search' do
    user = User.find_by_name('Demo')
    assert_equal 1, user.id
  end

end
