Rails.application.routes.draw do
  resources :expenses
  resources :categories
  resources :payment_methods

  root 'expenses#index'
  get "up" => "rails/health#show", as: :rails_health_check
end
