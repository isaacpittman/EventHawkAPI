class EventsController < ApplicationController
  before_action :authenticate_user
  before_action :set_event, only: [:show, :update]

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
    @event = Event.new(event_params)
    @event.event_id = generate_guid
    @event.host_id = get_user_id

    if @event.save
      render :json => @event.to_json(:except => :_id), status: :created
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      render :json => @event.to_json(:except => :_id), status: :accepted
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.where(event_id: params[:eventId])
  end
  
  # Only allow a trusted parameter "white list" through.
  def event_params
    params.require(:event).permit(:name, :description, :time, :location, :current_capacity, :total_capacity, :interest_rating, :category)
  end

  def generate_guid
    SecureRandom.hex(10)
  end

  def get_user_id
    decoded_token = JWT.decode token, Rails.application.secrets.secret_key_base, true, { :algorithm => 'HS256' }
    (decoded_token[0])['user_id']
  end

  def token
    params[:token] || token_from_request_headers
  end

  def token_from_request_headers
    unless request.headers['Authorization'].nil?
      request.headers['Authorization'].split.last
    end
  end
end