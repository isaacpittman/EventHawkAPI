class VotesController < ApplicationController
  before_action :authenticate_user
  before_action :set_vote, only: [:show, :update]

  # GET /votes/1
  def show
    if @vote.nil?
      render status: :not_found
    else
      render :json => @vote.to_json(:except => :_id), status: :ok
    end
  end

  # POST /votes
  def create
    p = post_params
    begin
      @jwt_token_user = User.find_by(user_id: get_user_id)
    rescue Exception => error
      render :json => error.to_json, status: :bad_request
      return
    end
    begin
      votes = Vote.where(voter_id: @jwt_token_user.user_id, event_id: p[:event_id])
      if votes.count == 0
        event = Event.find_by(event_id: p[:event_id])
        if @jwt_token_user.user_id == event.host_id
          render status: :forbidden
        else
          @vote = Vote.create(p)
          @vote.is_active = true
          @vote.vote_id = generate_guid
          @vote.voter_id = @jwt_token_user.user_id
          if @vote.save
            render :json => @vote.to_json(:except => :_id), status: :created
          else
            render json: @vote.errors, status: :unprocessable_entity
          end
        end
      else
        render :json => @vote.to_json(:except => :_id), status: :conflict
      end
    rescue Exception => error
      render :json => error.to_json, status: :bad_request
    end
  end

  # PATCH/PUT /votes/1
  def update
    begin
      @jwt_token_user = User.find_by(user_id: get_user_id)
    rescue Exception => error
      render :json => error.to_json, status: :bad_request
      return
    end
    begin
      if @jwt_token_user.user_id == @vote.voter_id
        if @vote.nil?
          render status: :not_found
        else
          if @vote.update(put_params)
            render :json => @vote.to_json(:except => :_id), status: :accepted
          else
            render json: @vote.errors, status: :unprocessable_entity
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
  def set_vote
    begin
      @vote = Vote.find_by(vote_id: params[:id])
    rescue Mongoid::Errors::DocumentNotFound
      @vote = nil
    end
  end

  # Only allow a trusted parameter "white list" through.
  def post_params
    params.require(:vote).permit(:value, :event_id)
  end

  def put_params
    params.delete :vote_id
    params.delete :voter_id
    params.delete :event_id
    params.delete :is_active
    params.permit(:value)
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
