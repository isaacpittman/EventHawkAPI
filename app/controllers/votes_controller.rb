class VotesController < ApplicationController
  before_action :set_vote, only: [:show, :update]

  # GET /votes/1
  def show
    render json: @vote, status: :ok
  end

  # POST /votes
  def create
    @vote = Vote.new(vote_params)

    if @vote.save
      render json: @vote, status: :created
    else
      render json: @vote.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /votes/1
  def update
    if @vote.update(vote_params)
      render json: @vote, status: :accepted
    else
      render json: @vote.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vote
      @vote = Vote.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def vote_params
      params.require(:vote).permit(:user_id, :value)
    end
end
