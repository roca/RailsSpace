require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
  include ApplicationHelper
  fixtures :users
  
  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @valid_user = users(:valid_user)
    @admin_user = users(:admin)
    authorize  @admin_user
  end

def test_delete_user_by_admin
    old_count = User.count 
    xhr :delete, :destroy, :id => @valid_user
    assert_response :success 
    assert_equal old_count-1, User.count 
  end 

  def test_delete_user_by_nonadmin
    authorize  @valid_user
    old_count = User.count 
    xhr :delete, :destroy, :id => @admin_user
    assert_response :redirect 
    assert_equal old_count, User.count 
  end 


end