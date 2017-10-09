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
            get '/' => 'api_users#show'
            put '/' => 'api_users#update'
		  end
	    end
	    scope '/events' do
		  get '/' => 'api_events#index'
		  post '/' => 'api_events#create'
		  scope '/:eventId' do
            get '/' => 'api_events#show'
            put '/' => 'api_events#update'
		    scope '/reviews' do
			  get '/' => 'api_reviews#index'
			  post '/' => 'api_reviews#create'
			  scope '/:reviewId' do
			    get '/' => 'api_reviews#show'
			    put '/' => 'api_reviews#update'
			  end
		    end
          end
        end
      end
    end
  end
end
