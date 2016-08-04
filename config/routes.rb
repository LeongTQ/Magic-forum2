Rails.application.routes.draw do
root "landing#index"
get :about, to: 'static_pages#about'
resources :topics
resources :posts 
end
