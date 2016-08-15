Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount ActionCable.server => '/cable'
  root "landing#index"
  get :about, to: 'static_pages#about'

  resources :topics, except: [:show] do
    resources :posts, except: [:show] do
      resources :comments, except: [:show]
    end
  end

  resources :users, only: [:new, :edit, :create, :update]
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets, only: [:new, :edit, :create, :update]
end
