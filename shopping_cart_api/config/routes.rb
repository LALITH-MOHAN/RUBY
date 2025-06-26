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

  resources :products
  # Defines the root path route ("/")
  root "products#index"
end
