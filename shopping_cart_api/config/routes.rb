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

  # Session verification
  get 'auth/me', to: 'auth#show'

  # Category-based product routes
  get 'products/categories', to: 'products#categories'
  get 'products/category/:category', to: 'products#by_category'

  # Main product routes
  resources :products

  # Cart routes
  scope :cart do
    get '/', to: 'cart#index'
    post '/', to: 'cart#create'
    put '/:id', to: 'cart#update'
    delete '/:id', to: 'cart#destroy'
    delete '/', to: 'cart#destroy'
  end

  # Order routes
  resources :orders, only: [:index, :create]

  root "products#index"
end