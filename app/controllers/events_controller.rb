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
      @events = Ticket.where(attendee_id: params[:attendedBy]).only(:event_id)
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
      @jwt_token_user = User.find_by(user_id: get_user_id)
    rescue Mongoid::Errors::DocumentNotFound
      render status: :bad_request
      return
    end
    begin
      @event = Event.find_by(p)
      render :json => @event.to_json(:except => :_id), status: :conflict
    rescue Mongoid::Errors::DocumentNotFound
      @event = Event.new(post_params)
      @event.is_active = true
      @event.event_id = generate_guid
      @event.host_id = @jwt_token_user.user_id
      if @event.save
        render :json => @event.to_json(:except => :_id), status: :created
      else
        render json: @event.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /events/1
  def update
    begin
      @jwt_token_user = User.find_by(user_id: get_user_id)
      if @jwt_token_user.user_id == @event.host_id
        if @event.update(put_params)
          render :json => @event.to_json(:except => :_id), status: :accepted
        else
          render json: @event.errors, status: :unprocessable_entity
        end
      else
        render status: :forbidden
        return
      end
    rescue Mongoid::Errors::DocumentNotFound
      render status: :bad_request
      return
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
    @event = Event.find_by(event_id: params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def post_params
    params.require(:event).permit(:name, :description, :time, :location, :total_capacity, :category)
  end

  def put_params
    params.delete :event_id
    params.delete :host_id
    params.delete :is_active
    params.permit(:name, :description, :time, :location, :total_capacity, :category)
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