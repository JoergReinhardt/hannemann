Hannemann::Application.routes.draw do

  # Session Routes
  # Resource Routen nur fuer :new, :create & :destroy

  match '/session', to: 'sessions#create',
                     as: 'sessions',
                     via: :post

  match '/session', to: 'sessions#destroy',
                     as: 'signout',
                     via: :delete

  match '/session/anmelden', to: 'sessions#new',
                     as: 'signin'

  match '/users/new',   to: 'users#new',
                        as: 'signup'

  resources :blogposts 

  resources :users 

  root :to => 'blogposts#index'
  

  # User Routes
  #
  # alle Routen die eine REST Ressource hat auf entsprechende URL's gemappt.
  # Das ginge auch "automagisch" mit der 'ressource' Funktion. Dabei wird aber
  # immer die Object ID als Parameter aus der URL genommen. Will man schoene
  # URL's dann muss man selber basteln.
  #
  # CAVE!!!  Die Routen muessen unbedingt in der richtigen Reihenfolge
  # aufgefuehrt werden. Die 'show', 'update' & 'destroy' Actions haben
  # identische URL's die sich lediglich in der HTTP Methode (GET, PUT, POST,
  # oder DELETE) unterscheiden.
  #
  # Die 'index' & 'create' Actions haben eine identische KUERZERE URL. Sobald
  # es einen match gibt, wird geroutet ==> stehen 'index', 'show', 'update',
  # oder 'destroy' vor 'create', landet der POST Request vom Formular des 'new'
  # controllers immer bei der falschen Action.
#
# match '/benutzer/anlegen',
#       to: 'users#new',
#       as: 'signup'

# match '/benutzer/:login/edit',
#       to: 'users#edit',
#       as: 'edit_user'

# match '/benutzer/:login',
#       to: 'users#update',
#       as: 'user',
#       via: :put

# match '/benutzer/:login',
#       to: 'users#destroy',
#       as: 'user',
#       via: :delete

# match '/benutzer/:login',
#       to: 'users#show',
#       as: 'user'

# match '/benutzer',
#       to: 'users#create',
#       as: 'users',
#       via: :post

# match '/benutzer',
#       to: 'users#index',
#       as: 'users'


  # Blogpost Routen

# match '/blog/new',
#       to: 'blogposts#new',
#       as: 'new_blogpost'

# match '/blog/:url_slug/edit',
#       to: 'blogposts#edit',
#       as: 'edit_blogpost'

# match '/blog/:url_slug',
#       to: 'blogposts#destroy',
#       as: 'blogpost',
#       via: :delete

# match '/blog/:url_slug',
#       to: 'blogposts#update',
#       as: 'blogpost',
#       via: :put

# match '/blog/:url_slug',
#       to: 'blogposts#show',
#       as: 'blogpost'

# match '/blog',
#       to: 'blogposts#create',
#       as: 'blogposts',
#       via: :post

#  match '/',
#        to: 'blogposts#index',
#        as: 'root'

#  get "login" "blogposts#index" as: :login

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
