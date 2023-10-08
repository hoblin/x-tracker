Rails.application.routes.draw do
  devise_for :users
  resources :tweets, only: %i[index show] do
    post "receive_metrics", on: :collection
  end

  root "welcome#index"
end
