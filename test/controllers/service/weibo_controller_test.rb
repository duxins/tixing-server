require 'test_helper'

class Service::WeiboControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
