Rails.application.routes.draw do
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

  # Add this for session verification
  get 'auth/me', to: 'auth#show'

  # Category-based product routes
  get 'products/categories', to: 'products#categories'
  get 'products/category/:category', to: 'products#by_category'

  # Main product routes
  resources :products

  # Root route
  root "products#index"
end