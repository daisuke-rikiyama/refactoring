Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  root 'welcome#index'
  
  get      'signup'      , to: 'users#new'
  get      'login'       , to: 'sessions#new'
  post     'login'       , to: 'sessions#create'
  delete   'logout'      , to: 'sessions#destroy'
  get      'ranking/have', to: 'ranking#have', as: 'ranking_have'
  get      'ranking/want', to: 'ranking#want', as: 'ranking_want'
  get      'myclips'     , to: 'clips#index'
  
  resources :users do
    get 'message_boards' , to: 'users#message_boards', as: 'message_boards'
    get 'favorites', on: :member
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :sessions, only: [:new, :create, :destroy]
  resources :items , only: [:new, :show]
  resources :ownerships, only: [:create , :destroy]
  resources :message_boards, only: [:index, :create, :show, :destroy] do
    resources :messages, only: [:create, :edit, :update, :destroy] do
      resources :clips, only: [:create, :destroy]
    end
    resources :favorites, only: [:create, :destroy]
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
