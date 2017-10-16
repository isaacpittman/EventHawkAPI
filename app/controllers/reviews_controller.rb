class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :update]

  # GET /reviews/1
  def show
    render json: @review, status: :ok
  end

  # POST /reviews
  def create
    @review = Review.new(review_params)

    if @review.save
      render json: @review, status: :created
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reviews/1
  def update
    if @review.update(review_params)
      render json: @review, status: :accepted
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:review_id])
    end

    # Only allow a trusted parameter "white list" through.
    def review_params
      params.require(:review).permit(:review_id, :reviewer_id, :host_prep, :matched_desc, :would_ret)
    end
end
