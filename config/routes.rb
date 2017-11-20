Rails.application.routes.draw do
  scope '/' do
		get '/', to: redirect('/api/v1')
		scope '/api' do
			get '/', to: redirect('/v1')
			scope '/v1' do
				get '/' => 'api_v_one#index'
				post '/login' => 'user_token#create'
				resources :users, :only => [:create, :show]
				resources :events, :except => [:new, :edit, :destroy]
				resources :votes, :only => [:create, :show, :update]
				resources :reviews, :only => [:create, :show, :update]
				resources :tickets, :only => [:create, :show, :destroy]
      end
    end
  end
end
