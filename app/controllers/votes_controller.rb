class VotesController < ApplicationController
  before_action :authenticate_user
  before_action :set_vote, only: [:show, :update]

  # GET /votes/1
  def show
    render :json => @vote.to_json(:except => :_id), status: :ok
  end

  # POST /votes
  def create
    @vote = Vote.new(vote_params)
    @vote.vote_id = generate_guid
    @vote.voter_id = get_user_id

    if @vote.save
      render :json => @vote.to_json(:except => :_id), status: :created
    else
      render json: @vote.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /votes/1
  def update
    if @vote.update(vote_params)
      render :json => @vote.to_json(:except => :_id), status: :accepted
    else
      render json: @vote.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vote
      @vote = Vote.where(vote_id: params[:voteId])
    end

    # Only allow a trusted parameter "white list" through.
    def vote_params
      params.require(:vote).permit(:value)
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
