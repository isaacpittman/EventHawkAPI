class TicketsController < ApplicationController
  before_action :authenticate_user
  before_action :set_ticket, only: [:show, :destroy]
  # TODO Enforce one vote per user per event
  # TODO Enforce GUID uniqueness

  # GET /tickets/1
  def show
    render :json => @ticket.to_json(:except => :_id), status: :ok
  end

  # POST /tickets
  def create
    p = post_params
    begin
      @jwt_token_user = User.find_by(user_id: get_user_id)
    rescue Mongoid::Errors::DocumentNotFound
      render status: :bad_request
      return
    end
    begin
      @ticket = Ticket.find_by(attendee_id: @jwt_token_user.user_id, event_id: p[:event_id])
      render :json => @ticket.to_json(:except => :_id), status: :conflict
    rescue Mongoid::Errors::DocumentNotFound
      @ticket = Ticket.create(p)
      @ticket.is_active = true
      @ticket.ticket_id = generate_guid
      @ticket.attendee_id = @jwt_token_user.user_id
      if @ticket.save
        render :json => @ticket.to_json(:except => :_id), status: :created
      else
        render json: @ticket.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /tickets/1
  def update
    begin
      @jwt_token_user = User.find_by(user_id: get_user_id)
      if @jwt_token_user.user_id == @ticket.attendee_id
        if @ticket.update(put_params)
          render :json => @ticket.to_json(:except => :_id), status: :accepted
        else
          render json: @ticket.errors, status: :unprocessable_entity
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

  def destroy
    @ticket.delete
    render status: :accepted
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_ticket
    @ticket = Ticket.find_by(ticket_id: params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def post_params
    params.require(:ticket).permit(:attending, :event_id)
  end

  def put_params
    params.delete :ticket_id
    params.delete :attendee_id
    params.delete :event_id
    params.delete :is_active
    params.permit(:attending)
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
