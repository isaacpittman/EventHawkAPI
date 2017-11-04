class UsersController < ApplicationController
  before_action :authenticate_user, only: [:show, :update]
  before_action :set_user, only: [:show, :update]

  # GET /users/1
  def show
    render :json => @user.to_json(:except => :_id), status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params)
    @user.user_id = generate_guid

    if @user.save
      render :json => @user.to_json(:except => :_id), status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render :json => @user.to_json(:except => :_id), status: :accepted
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.where(user_id: params[:userId]).without(:password_digest)
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password)
    end

    def generate_guid
      SecureRandom.hex(10)
    end
end
