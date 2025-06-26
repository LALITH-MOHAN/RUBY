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

  resources :products, defaults: { format: :json }

  root to: proc { [200, {}, ['{"status":"OK"}']] }
end
