class UsersController < ApplicationController
include ApplicationHelper
helper :profile, :avatar
before_filter :protect_admins, :only => [:destroy]
 
  def destroy
     
    @user = User.find(params[:id])
    @user.avatar.delete
    @user.destroy
    
    
    Friendship.destroy_all({:friend_id => @user.id})
 
    respond_to do |format| 
      format.js 
    end
  end
  


end