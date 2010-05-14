class Blog < ActiveRecord::Base
  belongs_to :user
  has_many :posts, :order => "created_at DESC",:dependent => :destroy
end