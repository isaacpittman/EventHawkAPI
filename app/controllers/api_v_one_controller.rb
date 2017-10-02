class ApiVOneController < ApplicationController
  def index
    render plain: 'Available Endpoints: /users /events'
   end
end