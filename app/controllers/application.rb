# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include ApplicationHelper
  


  before_filter :check_authorization
  
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_rails_space_session_id'

  def check_authorization
    authorization_token = cookies[:authorization_token]
    if authorization_token and not logged_in?
      user = User.find_by_authorization_token(authorization_token)
      user.login!(session) if user
    end
  end
  # Return true if a parameter corresponding to the given symbol was posted.
  def param_posted?(sym)
    request.post? and params[sym]
  end
 # Protect a page from unauthorized access.
  def protect
    unless logged_in?
      session[:protected_page] = request.request_uri
      flash[:notice] = "Please log in first"
      redirect_to :controller => "user", :action => "login"
      return false
    end
  end

  def protect_admins
  user = User.find(session[:user_id])
  unless user.friend_of_admin
      flash[:notice] = "You don't have the admin rights to do this!"
      redirect_to hub_url
      return false
    end
  
end
 def make_profile_vars
    @spec = @user.spec ||= Spec.new
    @faq = @user.faq ||= Faq.new 
    @blog = @user.blog ||= Blog.new  
    posts = @blog.posts
    @pages =  @posts = posts.paginate(:page => params[:page], :per_page => 3) 
 end

end
