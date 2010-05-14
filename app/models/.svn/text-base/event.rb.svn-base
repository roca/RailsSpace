class Event < ActiveRecord::Base
  belongs_to :user
  
  
  validates_presence_of :title,  :event_date
  validates_length_of :title, :maximum => DB_STRING_MAX_LENGTH
  validates_length_of :description,  :maximum => DB_TEXT_MAX_LENGTH
  
 # Prevent duplicate posts.
  validates_uniqueness_of :description, :scope => [:title, :user_id,:event_date]

 # Return true for a duplicate post (same title and body).
  def duplicate?
    event = Event.find_by_user_id_and_title_and_description_and_event_date(user_id, title, description,event_date)
    # Give self the id for REST routing purposes.
    self.id = event.id unless event.nil?
    not event.nil?
  end

   # Check authorization for destroying comments.
  def authorized?(in_user)
    user == in_user
  end
end
