Rails.application.routes.draw do
  root 'store#index', as: 'store_index'
  match '*path', to: redirect('404'), via: :all, constraints: -> (req) { req.headers['User-Agent'] =~ FIREFOX_BROWSER_REGEX }
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :users 
  resources :orders
  resources :line_items
  resources :carts

  resources :products, path: '/books' do
    get :who_bought, on: :member
  end

  resources :support_requests, only: [ :index, :update ]

  get 'my-orders', to: 'users#orders'
  get 'my-items', to: 'users#items'

  namespace :admin do
    get 'reports', to: 'reports#index'
    get 'categories', to: 'categories#index'
    get '/', to: redirect('/admin/reports')
  end

  resources :categories do
    resources :products, path: '/books', as: 'books', constraints: { category_id: CATEGORY_ID_REGEX }
    resources :products, path: '/books', as: 'books', to: redirect('/')
  end

  post 'language', to: 'users#language', as: 'user_language'
end
