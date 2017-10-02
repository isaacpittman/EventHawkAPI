class ApiUserController < ApplicationController
  def show
    require 'json'

    review = {
	  'reviewer_id' => '001'
	  'host_prep_score' => 5
	  'match_score' => 5
	  'would_return' => true
    }

	render json: JSON[review]
  end
  
  def update
	render status: 200
  end
end