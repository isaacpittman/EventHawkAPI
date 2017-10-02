class ApiUserController < ApplicationController
  def show
    require 'json'

    user = {
      'email' => 'joshua_smolinski@student.uml.edu'
	  'name' => 'Josh Smolinski'
	  'rating' => 87
    }

	render json: JSON[user]
  end
  
  def update
	render status: 200
  end
end