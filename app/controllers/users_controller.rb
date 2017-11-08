class UsersController < ApplicationController
  before_action :authenticate_user, only: [:show, :update]
  before_action :set_user, only: [:show, :update]

  # TODO Ensure no duplicates
  # TODO Enforce GUID uniqueness
  # TODO Enable delete
  # TODO Fix put

  # GET /users/1
  def show
    render :json => @user.to_json(:except => :_id), status: :ok
  end

  # POST /users
  def create
    @user = User.new(post_params)
    @user.user_id = generate_guid

    if @user.save
      render :json => @user.to_json(:except => :_id), status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(put_params)
      render :json => @user.to_json(:except => :_id), status: :accepted
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      params.delete :matched_desc
      params.delete :host_prep
      params.delete :would_ret
      @user = User.where(user_id: params[:userId])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:user).permit(:first_name, :last_name, :email, :password)
    end

    def put_params
      params.delete :user_id
      params.delete :email
      params.delete :password
      params.delete :password_digest
      params.require(:user).permit(:first_name, :last_name)
    end

    def generate_guid
      SecureRandom.hex(10)
    end
end
