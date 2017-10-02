class ApiEventController < ApplicationController
  def show
    require 'json'

    event = {
      'userId' => '001'
	  'name' => 'Basketball'
	  'location' => 'South Campus'
    }

	render json: JSON[event]
  end
  
  def update
	render status: 200
  end
end