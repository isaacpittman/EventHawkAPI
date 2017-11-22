class UsersController < ApplicationController
  before_action :authenticate_user, only: [:show]
  before_action :set_user, only: [:show]

  # GET /users/1
  def show
    if @user.nil?
      render status: :not_found
    else
      render :json => @user.to_json(:except => :_id), status: :ok
    end
  end

  # POST /users
  def create
    p = post_params
    begin
      users = User.where(first_name: p[:first_name], last_name: p[:last_name])
      if users.count == 0
        @user = User.new(p)
        @user.is_active = true
        @user.user_id = generate_guid
        @user.email = @user.first_name + "_" + @user.last_name + "@student.uml.edu"
        if @user.save
          render :json => @user.to_json(:except => :_id), status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      else
        render status: :conflict
      end
    rescue Exception => error
      render :json => error.to_json, status: :bad_request
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    begin
      @user = User.find_by(user_id: params[:id])
    rescue Mongoid::Errors::DocumentNotFound
      @user = nil
    end
  end

  # Only allow a trusted parameter "white list" through.
  def post_params
    params.require(:user).permit(:first_name, :last_name, :password)
  end

  def generate_guid
    SecureRandom.hex(10)
  end
end
