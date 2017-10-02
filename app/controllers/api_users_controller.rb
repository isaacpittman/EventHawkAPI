class ApiUsersController < ApplicationController
  def index
    require 'json'

    users = {
      'userIds' => ['001','002','003','004','005']
    }

	render json: JSON[users]
   end
  
  def create
	render status: 201
  end
end