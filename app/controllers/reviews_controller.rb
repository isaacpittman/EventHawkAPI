class ReviewsController < ApplicationController
  before_action :authenticate_user
  before_action :set_review, only: [:show, :update]

  # GET /reviews/1
  def show
    if @review.nil?
      render status: :not_found
    else
      render :json => @review.to_json(:except => :_id), status: :ok
    end
  end

  # POST /reviews
  def create
    p = post_params
    begin
      @jwt_token_user = User.find_by(user_id: get_user_id)
    rescue Exception => error
      render :json => error.to_json, status: :bad_request
      return
    end
    begin
      reviews = Review.where(reviewer_id: @jwt_token_user.user_id, event_id: p[:event_id])
      if reviews.count == 0
        event = Event.find_by(event_id: p[:event_id])
        if @jwt_token_user.user_id == event.host_id
          render status: :forbidden
        else
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
      else
        render :json => @review.to_json(:except => :_id), status: :conflict
      end
    rescue Exception => error
      render :json => error.to_json, status: :bad_request
    end
  end

  # PATCH/PUT /reviews/1
  def update
    begin
      @jwt_token_user = User.find_by(user_id: get_user_id)
    rescue Exception => error
      render :json => error.to_json, status: :bad_request
      return
    end
    begin
      if @jwt_token_user.user_id == @review.reviewer_id
        if @review.nil?
          render status: :not_found
        else
          if @review.update(put_params)
            render :json => @review.to_json(:except => :_id), status: :accepted
          else
            render json: @review.errors, status: :unprocessable_entity
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
  def set_review
    begin
      @review = Review.find_by(review_id: params[:id])
    rescue Mongoid::Errors::DocumentNotFound
      @review = nil
    end
  end

  # Only allow a trusted parameter "white list" through.
  def post_params
    params.require(:review).permit(:host_prep, :matched_desc, :would_ret, :event_id)
  end

  def put_params
    params.delete :review_id
    params.delete :reviewer_id
    params.delete :event_id
    params.delete :is_active
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
