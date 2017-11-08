Rails.application.routes.draw do
  scope '/' do
    get '/', to: redirect('/api/v1')
    scope '/api' do
	  get '/', to: redirect('/v1')
      scope '/v1' do
	    get '/' => 'api_v_one#index'
				scope '/login' do
		  		post '/' => 'user_token#create'
				end
        scope '/users' do
          post '/' => 'users#create'
          scope '/:userId' do
            get '/' => 'users#show'
            put '/' => 'users#update'
		  		end
	    	end
	    	scope '/events' do
		  		get '/' => 'events#index'
		  		post '/' => 'events#create'
					scope '/:eventId' do
						get '/' => 'events#show'
						put '/' => 'events#update'
          end
				end
		    scope '/reviews' do
			  	post '/' => 'reviews#create'
			  	scope '/:reviewId' do
			    	get '/' => 'reviews#show'
			    	put '/' => 'reviews#update'
			  	end
		    end
				scope '/votes' do
			  	post '/' => 'votes#create'
			  	scope '/:voteId' do
			    	get '/' => 'votes#show'
						put '/' => 'votes#update'
			  	end
				end
      end
    end
  end
end
