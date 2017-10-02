class ApiUserController < ApplicationController
  def show
    render plain: 'Available Commands: get, put'
  end
  
  def update
	render status: 200
  end
end