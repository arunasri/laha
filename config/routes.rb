Digital55::Application.routes.draw do

  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout

  match '/tags/search',     :to => "tags#search"
  match '/players/next',    :to => "players#next"

  resources :shows do
    get 'query', :on => :collection
  end

  resources :feeds do
    get 'latest', :on => :member
  end

  resources :videos do
    member do
      get 'next'
      get 'previous'
    end

    get 'shows', :on => :collection
  end

  match '/:language/channels/:id/:page' => 'channels#show', :constraints => { :page => /\d+/ }

  scope ":language" do
    resources :channels, :except => [ :create, :destroy ]  do
      resources :videos, :only => [ :index ]
    end
  end

  root :to => "players#play"
end
