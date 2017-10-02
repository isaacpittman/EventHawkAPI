class ApiEventController < ApplicationController
  def show
    render plain: 'Available Commands: get, put --- Available Endpoints: /reviews'
  end
  
  def update
	render status: 200
  end
end