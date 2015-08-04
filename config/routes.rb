Rails.application.routes.draw do
	root 'articles#index'
	resources :articles do
		resources :comments
	end
	resources :tags
	resources :authors
	
	get 'popular' => 'articles#show_popular_articles'
	get 'monthly/:month' => 'articles#show_by_month', as: :monthly

	get 'rss_feed' => 'articles#rss_feed', :as => :rss_feed, :defaults => { :format => 'rss'}
		
	resources :author_sessions, only: [ :new, :create, :destroy ]
	get 'login' => 'author_sessions#new'
	get 'logout' => 'author_sessions#destroy'

end
