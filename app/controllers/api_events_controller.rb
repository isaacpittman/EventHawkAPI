class ApiEventsController < ApplicationController
  def index
    require 'json'

    events = {
      'eventIds' => ['001','002','003','004','005']
    }

	render json: JSON[events]
   end
  
  def create
	render status: 201
  end
end