class EventsController < ApplicationController
  before_action :authenticate_user
  before_action :set_event, only: [:show, :update]

  # TODO Ensure no duplicates
  # TODO Enforce GUID uniqueness
  # TODO Enable delete
  # TODO Fix put

  # GET /events
  def index
    @events = Event.all.only(:event_id)
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
    @event = Event.new(post_params)
    @event.current_capacity = 0
    @event.event_id = generate_guid

    if @event.save
      render :json => @event.to_json(:except => :_id), status: :created
    else
      render json: @event.errors, status: :unprocessable_entity
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
    params.delete :interest_rating
    @event = Event.where(event_id: params[:eventId])
  end
  
  # Only allow a trusted parameter "white list" through.
  def post_params
    params.require(:event).permit(:name, :description, :time, :location, :current_capacity, :total_capacity, :category, :host_id)
  end

  def put_params
    params.delete :event_id
    params.delete :host_id
    params.require(:event).permit(:name, :description, :time, :location, :current_capacity, :total_capacity, :category)
  end

  def generate_guid
    SecureRandom.hex(10)
  end
end