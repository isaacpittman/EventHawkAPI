class ApiReviewsController < ApplicationController
  def index
    render plain: 'Available Commands: get, post --- Available Endpoints: /reviewId'
  end
  
  def create
	render status: 201
  end
end