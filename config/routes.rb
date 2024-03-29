 Studyvault::Application.routes.draw do
  
  root :to => "pages#index"
  
  resources :users do
    get 'add', :on => :member
  end
  
  resources :uploads, :only =>[:create, :destroy, :show]
  
  resources :uploads do
    get 'download', :on => :member
  end
  
  resources :sessions, :only => [:new, :create, :destroy]
  
  #can see all requests by school
  resources :schools do
    resources :requests
  end
  
  resources :courses
  resources :comments
  
  resources :downloads
  
  resources :purchases
  
  #can access a response by the request
  resources :requests do
    resources :responses
  end
  
  resources :responses do
    get 'download', :on => :member
    get 'accept', :on => :member
  end
  
  match '/signup',    :to => 'users#new'
  match '/signin',    :to => 'sessions#new'
  match '/signout',   :to => 'sessions#destroy'
  match '/about',     :to => 'pages#about'
  match '/aboutswag', :to => 'pages#aboutswag'
  match '/terms',     :to => 'pages#terms'
  match '/upload',    :to => 'pages#upload'
  match '/search',     :to => 'pages#search'
  
  match '/schoolsearch', :to => 'schools#search'
  match '/coursesearch', :to => 'courses#search'
  match '/professors',   :to => 'pages#professors'
  
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
