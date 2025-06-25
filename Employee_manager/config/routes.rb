Rails.application.routes.draw do
  # Setup Devise routes for API-only
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

  resources :products, defaults: { format: :json }

  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check

  # Set root path to a simple health or JSON response (optional)
  root to: proc { [200, {}, ['{"status":"OK"}']] }
end
