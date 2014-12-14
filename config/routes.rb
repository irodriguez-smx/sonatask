Rails.application.routes.draw do
  devise_for :users, :controllers => {sessions: 'sessions', registrations: 'registrations'} 
  get 'helper/index'
  get 'token' => 'helper#token' 
  resources :users, :only=>[],:shallow=>true do
    resources :tasks, :only=>[:create,:destroy,:update,:delete,:index] do
      collection do
        post :sort
        post :search
      end
    end
  end
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'helper#index'
end
