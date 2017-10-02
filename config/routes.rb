Rails.application.routes.draw do
  scope '/' do
    get '/', to: redirect('/api/v1')
    scope '/api' do
	  get '/', to: redirect('/v1')
      scope '/v1' do
	    get '/' => 'api_v_one#index'
        scope '/users' do
          get '/' => 'api_users#index'
          post '/' => 'api_users#create'
          scope '/:userId' do
            get '/' => 'api_user#show'
            put '/' => 'api_user#update'
		  end
	    end
	    scope '/events' do
		  get '/' => 'api_events#index'
		  post '/' => 'api_events#create'
		  scope '/:eventId' do
            get '/' => 'api_event#show'
            put '/' => 'api_event#update'
		    scope '/reviews' do
			  get '/' => 'api_reviews#index'
			  post '/' => 'api_reviews#create'
			  scope '/:reviewId' do
			    get '/' => 'api_review#show'
			    put '/' => 'api_review#update'
			  end
		    end
          end
        end
      end
    end
  end
end
