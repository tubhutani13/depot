Rails.application.routes.draw do
  root 'store#index', as: 'store_index'
  
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :users do 
    collection do
      get 'orders'
      get 'line_items'
    end
  end
  resources :orders
  resources :line_items
  resources :carts

  resources :products do
    get :who_bought, on: :member
  end

  resources :support_requests, only: [ :index, :update ]

  namespace :admin do
    get 'reports', to: 'reports#index'
    get 'categories', to: 'categories#index'
    get '/', to: redirect('/admin/reports')
  end
end
