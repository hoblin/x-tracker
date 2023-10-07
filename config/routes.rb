Rails.application.routes.draw do
  resources :tweets, only: %i[index show]

  root "welcome#index"
end
