Checkout::Application.routes.draw do

  # extra collection routes used on 'brands' resource
  brands_collection_routes = Proc.new do
    get 'checkoutable'
  end

  # extra collection routes used on 'models' resource
  models_collection_routes = Proc.new do
    get 'checkoutable'
  end

  # extra collection routes used on 'kits' resource
  kits_collection_routes = Proc.new do
    get 'checkoutable'
    get 'not_checkoutable'
    get 'tombstoned'
  end

  root :to => 'models#checkoutable'

  # devise_for :users, ActiveAdmin::Devise.config
  # devise_for :users

  devise_for :user, skip: :registrations
  devise_scope :user do
    # remove the route for the registration#destroy action
    resource :registration,
    only: [:new, :create, :edit, :update],
    path: 'user',
    path_names: { new: 'sign_up' },
    controller: 'devise/registrations',
    as: :user_registration do
      get :cancel
    end
  end

  ActiveAdmin.routes(self)

  resources :asset_tags
  resources :brands do
    collection &brands_collection_routes
    resources :models do
      collection &models_collection_routes
    end
  end
  resources :budgets
  resources :business_hours
  resources :business_hour_exceptions
  resources :categories do
    resources :models do
      collection &models_collection_routes
    end
  end
  resources :components
  resources :kits do
    collection &kits_collection_routes
    resources :reservations, :only => [:index, :new]
  end
  resources :locations
  resources :models do
    collection &models_collection_routes
    resources :parts
    resources :reservations, :only => [:new]
  end
  resources :reservations
  resource :users do
    resources :reservations
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
