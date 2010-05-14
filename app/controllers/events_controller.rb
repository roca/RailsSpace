class EventsController < ApplicationController
  helper :profile
  before_filter :protect 
  #before_filter :protect_event, :only => [:show, :edit, :update, :destroy]
 before_filter :protect_event, :only => [ :edit, :update, :destroy]

  
  PER_PAGE = 10
  # GET /events
  # GET /events.xml
  def index
   
    @user = User.find(session[:user_id])
    events = @user.events
    
    @friends_events = Array.new
     @user.friends.each do  |f| 
      if  f.events.size != 0
        @friends_events << f.events
      end
    end
      
   
    @pages =  @events = events.paginate(:page => params[:page], :per_page => PER_PAGE) 
 
    @title = "Event Management"
    
    if params[:value] != 's' 
    @month = Time.now.month 
    @year = Time.now.year 
    else 
    @month = params[:month].to_i 
    @year = params[:year].to_i 
    end 

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
   
    @event = Event.find(params[:id])
    @title = @event.title
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new
    @title = "Add a new event"

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
     @title = 'Edit #{@event.title}'
     
  end

  # POST /events
  # POST /events.xml
  def create
     @user = User.find(session[:user_id])
     @event = Event.new(params[:event])
     @event.user = @user

    respond_to do |format|
      if @user.events << @event
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to(@event) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to(@event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end
  
  def showspecialday
  @specialday_day = params[:id]
    respond_to do |format|
      format.js   # showspecialday.js.rjs 
    end 
  end
  
  def hidespecialday
 @specialday_day = params[:id]
    respond_to do |format|
      format.js   # resetspecialday.js.rjs 
    end 
  end
  
  private

  # Ensure that user is blog owner, and create @blog.
  def protect_event
    @event = Event.find(params[:id])
    user = User.find(session[:user_id])
    unless @event.user == user
      flash[:notice] = "That isn't your Event!"
      redirect_to hub_url
      return false
    end
  end
end
