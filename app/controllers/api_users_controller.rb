class ApiUsersController < ApplicationController
  def index
    render plain: 'Available Commands: get, post --- Available Endpoints: /userId'
  end
  
  def create
	render status: 201
  end
end