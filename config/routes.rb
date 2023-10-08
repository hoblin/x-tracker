Rails.application.routes.draw do
  devise_for :users
  resources :tweets, only: %i[index show new create]
  get "track/:id.user.js", to: "tweets#track", as: :track_user_js
  post "receive_metrics", to: "tweets#receive_metrics", as: :receive_metrics

  root "welcome#index"
end
