Rails.application.routes.draw do
  devise_for :users
  resources :tweets, only: %i[index show]

  root "welcome#index"
end
