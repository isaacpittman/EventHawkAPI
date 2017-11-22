class TicketsController < ApplicationController
  before_action :authenticate_user
  before_action :set_ticket, only: [:show, :destroy]

  # GET /tickets/1
  def show
    if @ticket.nil?
      render status: :not_found
    else
      render :json => @ticket.to_json(:except => :_id), status: :ok
    end
  end

  # POST /tickets
  def create
    p = post_params
    begin
      @jwt_token_user = User.find_by(user_id: get_user_id)
    rescue Exception => error
      render :json => error.to_json, status: :bad_request
      return
    end
    begin
      tickets = Ticket.where(attendee_id: @jwt_token_user.user_id, event_id: p[:event_id])
      if tickets.count == 0
        event = Event.find_by(event_id: p[:event_id])
        if @jwt_token_user.user_id == event.host_id
          render status: :forbidden
        else
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
      else
        render :json => @ticket.to_json(:except => :_id), status: :conflict
      end
    rescue Exception => error
      render :json => error.to_json, status: :bad_request
    end
  end

  def destroy
    if @ticket.nil?
      render status: :not_found
    else
      @ticket.delete
      render status: :accepted
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_ticket
    begin
      @ticket = Ticket.find_by(ticket_id: params[:id])
    rescue Mongoid::Errors::DocumentNotFound
      @ticket = nil
    end
  end

  # Only allow a trusted parameter "white list" through.
  def post_params
    params.require(:ticket).permit(:event_id)
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
