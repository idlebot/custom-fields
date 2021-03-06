Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'pages#home'

  get 'signup', to: 'users#new'
  resources :users, except: [:new, :index, :destroy, :show]

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :contacts, except: [:show]

  resources :custom_fields, except: [:show]

end
