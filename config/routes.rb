Digital55::Application.routes.draw do

  match "/auth/:provider/callback" => "sessions#create"
  match "/admin"   => "sessions#admin", :as => :signout
  match "/signout" => "sessions#destroy", :as => :signout

  match '/tags/search',     :to => "tags#search"
  match '/players/next',    :to => "players#next"

  resources :shows do
    get 'query', :on => :collection
  end

  resources :feeds do
    get 'latest', :on => :member
  end

  resources :videos

  root :to => "players#play"
end
