class ApiUsersController < ApplicationController
  def index
    render status: 200
   end
  
  def create
	render status: 201
  end
end