class ApiEventsController < ApplicationController
  def index
    render plain: 'Available Commands: get, post --- Available Endpoints: /eventId'
  end
  
  def create
	render status: 201
  end
end