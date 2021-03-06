Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'venues#index'
  #
  # post '/search' => "venues#search", as: :search
  #
  # resources :venues


    root 'venues#index'
    post '/find_venues' => 'venues#find_venues', as: :find_venues
    post '/user_tips' =>'user_tips#create'
    get '/user_tips/:id' =>'user_tips#show'
    # post '/find_venues' => 'venues#find_venues', as: :find_venues

  # root 'venues#index'
  # post '/search_yelp' => 'venues#search_yelp', as: :search_yelp
  # get '/search_json' => 'venues#search', as: :search_json

  # post '/search_foursquare' => 'venues#search_foursquare', as: :search_foursquare
  # get 'venues/show' => 'venues#show', as: :venues


# find today
# find close time
# subtract

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
