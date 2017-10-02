class ApiUsersController < ApplicationController
  def index
    require 'json'

    reviews = {
      'reviewIds' => ['001','002','003','004','005']
    }

	render json: JSON[reviews]
   end
  
  def create
	render status: 201
  end
end