class EventsController < ApplicationController
  before_action :authenticate_user
  before_action :set_token_user, only: [:create, :show, :update]
  before_action :set_event, only: [:show, :update]

  # GET /events
  def index
    begin
      @events = nil
      if params.key?("attendedBy")
        @events = Ticket.where(attendee_id: params[:attendedBy]).only(:event_id)
      elsif params.key?("hostedBy")
        @events = Event.where(host_id: params[:hostedBy]).only(:event_id)
      end

      idArray = []
      if @events.nil?
        if params.key?("category") && params.key?("location")
          @events = Event.where(category: params[:category], location: params[:location]).only(:event_id, :time)
        elsif params.key?("category") && !params.key?("location")
          @events = Event.where(category: params[:category]).only(:event_id, :time)
        elsif !params.key?("category") && params.key?("location")
          @events = Event.where(location: params[:location]).only(:event_id, :time)
        else
          @events = Event.all.only(:event_id, :time)
        end
        now = DateTime.now
        @events.each do |p|
          if p.time > now
            idArray.push p.event_id
          end
        end
      else
        @events.each do |p|
          idArray.push p.event_id
        end
      end
      render :json => idArray.to_json, status: :ok
    rescue Exception => error
      render :json => error.to_json, status: :bad_request
    end
  end

  # GET /events/1
  def show
    if @jwt_token_user.nil?
      render :json => error.to_json, status: :bad_request
      return
    end
    if @event.nil?
      render status: :not_found
    else
      h = JSON.parse(@event.to_json(:except => :_id))
      h[:_my_vote] = get_my_vote_id
      h[:_my_review] = get_my_review_id
      h[:_my_ticket] = get_my_ticket_id
      render :json => h.to_json, status: :ok
    end
  end

  # POST /events
  def create
    p = post_params
    if @jwt_token_user.nil?
      render :json => error.to_json, status: :bad_request
      return
    end
    begin
      events = Event.where(p)
      if events.count == 0
        @event = Event.new(post_params)
        @event.is_active = true
        @event.event_id = generate_guid
        @event.host_id = @jwt_token_user.user_id
        if @event.save
          render :json => @event.to_json(:except => :_id), status: :created
        else
          render json: @event.errors, status: :unprocessable_entity
        end
      else
        render :json => @event.to_json(:except => :_id), status: :conflict
      end
    rescue Exception => error
      render :json => error.to_json, status: :bad_request
    end
  end

  # PATCH/PUT /events/1
  def update
    if @jwt_token_user.nil?
      render :json => error.to_json, status: :bad_request
      return
    end
    begin
      if @jwt_token_user.user_id == @event.host_id
        if @event.nil?
          render status: :not_found
        else
          if @event.update(put_params)
            render :json => @event.to_json(:except => :_id), status: :accepted
          else
            render json: @event.errors, status: :unprocessable_entity
          end
        end
      else
        render status: :forbidden
        return
      end
    rescue Exception => error
      render :json => error.to_json, status: :bad_request
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
    begin
      @event = Event.find_by(event_id: params[:id])
    rescue Mongoid::Errors::DocumentNotFound
      @event = nil
    end
  end

  def set_token_user
    begin
      @jwt_token_user = User.find_by(user_id: get_user_id)
    rescue Exception => error
      @jwt_token_user = nil
    end
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

  def get_my_vote_id
    begin
      vote = Vote.find_by(event_id: params[:id], voter_id: @jwt_token_user.user_id)
      vote.vote_id
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end
  end

  def get_my_review_id
    begin
      review = Review.find_by(event_id: params[:id], reviewer_id: @jwt_token_user.user_id)
      review.review_id
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end
  end

  def get_my_ticket_id
    begin
      ticket = Ticket.find_by(event_id: params[:id], attendee_id: @jwt_token_user.user_id)
      ticket.ticket_id
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end
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