class ReviewsController < ApplicationController
  before_action :authenticate_user
  before_action :set_review, only: [:show, :update]
  # TODO Enforce one vote per user per event
  # TODO Enforce GUID uniqueness

  # GET /reviews/1
  def show
    render :json => @review.to_json(:except => :_id), status: :ok
  end

  # POST /reviews
  def create
    p = post_params
    begin
      @jwt_token_user = User.find_by(user_id: get_user_id)
    rescue Mongoid::Errors::DocumentNotFound
      render status: :bad_request
      return
    end
    begin
      @review = Review.find_by(reviewer_id: @jwt_token_user.user_id, event_id: p[:event_id])
      render :json => @review.to_json(:except => :_id), status: :conflict
    rescue Mongoid::Errors::DocumentNotFound
      @review = Review.new(p)
      @review.is_active = true
      @review.review_id = generate_guid
      @review.reviewer_id = @jwt_token_user.user_id
      if @review.save
        render :json => @review.to_json(:except => :_id), status: :created
      else
        render json: @review.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /reviews/1
  def update
    if @review.update(put_params)
      render :json => @review.to_json(:except => :_id), status: :accepted
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find_by(review_id: params[:reviewId])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:review).permit(:host_prep, :matched_desc, :would_ret, :event_id)
    end

    #TODO Move this to validation and supply an error
    def put_params
      params.delete :review_id
      params.delete :reviewer_id
      params.delete :event_id
      params.permit(:host_prep, :matched_desc, :would_ret)
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
