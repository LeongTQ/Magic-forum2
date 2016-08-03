Rails.application.routes.draw do
root "landing#index"
get :about, to: 'static_pages#about'
end
