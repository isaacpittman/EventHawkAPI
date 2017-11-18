class EventsController < ApplicationController
  before_action :authenticate_user
  before_action :set_event, only: [:show, :update]

  # TODO Enforce GUID uniqueness
  # TODO Enable delete

  # GET /events
  def index
    if params.key?("category")
      @events = Event.where(category: params[:category]).only(:event_id)
    elsif params.key?("attendedBy")
      @events = Ticket.where(attendee_id: params[:attendedBy], attending: true).only(:event_id)
    elsif params.key?("hostedBy")
      @events = Event.where(host_id: params[:hostedBy]).only(:event_id)
    else
      @events = Event.all.only(:event_id)
    end
    idArray = []
    @events.each do |p|
      idArray.push p.event_id
    end
    render :json => idArray.to_json, status: :ok
  end
  
  # GET /events/1
  def show
    render :json => @event.to_json(:except => :_id), status: :ok
  end
  
  # POST /events
  def create
    p = post_params
    begin
      @event = Event.find_by(p)
      render :json => @event.to_json(:except => :_id), status: :conflict
    rescue Mongoid::Errors::DocumentNotFound
      @event = Event.new(post_params)
      @event.is_active = true
      @event.event_id = generate_guid
      if @event.save
        render :json => @event.to_json(:except => :_id), status: :created
      else
        render json: @event.errors, status: :unprocessable_entity
      end
    end
  end
  
  # PATCH/PUT /events/1
  def update
    if @event.update(put_params)
      render :json => @event.to_json(:except => :_id), status: :accepted
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_event
    params.delete :_interest_rating
    params.delete :_current_capacity
    params.delete :_review_matched_desc
    params.delete :_review_host_prep
    params.delete :_review_would_ret
    params.delete :_my_vote
    params.delete :_my_review
    params.delete :_my_ticket
    @event = Event.find_by(event_id: params[:eventId])
  end
  
  # Only allow a trusted parameter "white list" through.
  def post_params
    params.require(:event).permit(:name, :description, :time, :location, :total_capacity, :category, :host_id)
  end

  def put_params
    params.delete :event_id
    params.delete :host_id
    params.permit(:name, :description, :time, :location, :total_capacity, :category)
  end

  def generate_guid
    SecureRandom.hex(10)
  end
end