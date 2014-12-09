require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'test', password: '1234')
  end

  test 'should generate auth token properly' do
    @user.save!
    assert_match /^[a-z0-9]{40}$/, @user.auth_token
  end

  test 'username should be valid' do
    invalid_names = [nil, '', '123', 'a' * 16, '    ', '@@@@']
    invalid_names.each do |invalid_name|
      @user.name = invalid_name
      assert_not @user.valid?, "username '#{@user.name}' is invalid"
    end
  end

  test 'password should not be valid' do
    invalid_passwords = [nil, '', '12']
    invalid_passwords.each do |invalid_password|
      assert_not User.new(name: '1234', password: invalid_password).valid?, "#{invalid_password} is invalid"
    end
  end

  test 'should not query for disabled user' do
    @user.save!
    assert User.find_by_name(@user.name)

    @user.update(disabled: true)
    assert_not User.find_by_name(@user.name)
  end

  test 'should not create duplicate user' do
    @duplicate_user = @user.dup
    @user.save!
    assert_not @duplicate_user.valid?
  end

  test 'should not update if username exists' do
    @user.save!
    @user.name = 'demo'
    assert_not @user.valid?
  end

  test 'should perform case-insensitive search' do
    @user.save!
    assert_not User.find_by_name(@user.name.upcase).nil?
  end

end
