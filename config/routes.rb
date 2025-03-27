Rails.application.routes.draw do
  devise_for :users
  
  root "home#index"

  # Tambahkan route untuk aksi products
  get 'home/products', to: 'products#index', as: 'home_products'
  post 'home/products', to: 'products#create', as: 'home_products_create'
  delete 'home/products/:id', to: 'products#destroy', as: 'home_products_delete'

  # Tambahkan route untuk aksi leads
  get 'home/leads', to: 'leads#index', as: 'home_leads'
  post 'home/leads', to: 'leads#create', as: 'home_leads_create'
  patch 'home/leads/:id', to: 'leads#ajukan', as: 'home_leads_ajukan'
  post 'home/leads/approve', to: 'leads#approve', as: 'home_leads_approve'
  delete 'home/leads/:id', to: 'leads#destroy', as: 'home_leads_delete'

  # Tambahkan route untuk aksi customers
  get 'home/customers', to: 'customers#index', as: 'home_customers'

  get 'home/users', to: 'users#index', as: 'home_users'
  post 'home/users', to: 'users#create', as: 'home_users_create'
  delete 'home/users/:id', to: 'users#destroy', as: 'home_users_delete'

  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy'     
  end

  resources :leads, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :customers, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :products, only: [:index, :new, :create, :edit, :update, :destroy]

  get 'dashboard', to: 'dashboard#index', as: 'dashboard'
end