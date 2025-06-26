Rails.application.routes.draw do
  # Devise auth routes
  devise_for :users,
             defaults: { format: :json },
             path: '',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               registration: 'register'
             },
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }

  # Category-based product routes
  get 'products/categories', to: 'products#categories'
  get 'products/category/:category', to: 'products#by_category'

  # Main product routes
  resources :products

  # Root route
  root "products#index"
end
