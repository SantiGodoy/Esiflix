Rails.application.routes.draw do
  
  root :to => 'catalog#index'

  get 'about' => 'about#index'
  get 'forum' => 'forum#index'
  get 'checkout' => 'checkout#index'
  get 'admin/director' => 'admin/director#index'
  get 'admin/producer' => 'admin/producer#index'
  get 'admin/film' => 'admin/film#index'
  get 'admin/order' => 'admin/order#index'

  get 'about/index'

  get 'admin/director/new'
  post 'admin/director/create'
  get 'admin/director/edit'
  post 'admin/director/update'
  post 'admin/director/destroy'
  get 'admin/director/show'
  get 'admin/director/show/:id' => 'admin/director#show'
  get 'admin/director/index' 
  
  get 'admin/producer/new'
  post 'admin/producer/create'
  get 'admin/producer/edit'
  post 'admin/producer/update'
  post 'admin/producer/destroy'
  get 'admin/producer/show'
  get 'admin/producer/show/:id' => 'admin/producer#show'
  get 'admin/producer/index'

  get 'admin/film/new'
  post 'admin/film/create'
  get 'admin/film/edit'
  post 'admin/film/update'
  post 'admin/film/destroy'
  get 'admin/film/show'
  get 'admin/film/show/:id' => 'admin/film#show'
  get 'admin/film/index'

  post 'admin/order/close'
  post 'admin/order/destroy'
  get 'admin/order/show'
  get 'admin/order/show/:id' => 'admin/order#show'
  get 'admin/order/index'

  get 'catalog/show'
  get 'catalog/show/:id' => 'catalog#show'
  get 'catalog/index'
  get 'catalog/latest'
  get 'catalog/rss'

  get 'cart/add'
  post 'cart/add'
  get 'cart/remove'
  post 'cart/remove'
  get 'cart/clear'
  post 'cart/clear'

  get 'user_sessions/new'
  get 'user_sessions/create' # for showing failed login screen after restarting web server
  post 'user_sessions/create'
  get 'user_sessions/destroy'

  get 'checkout/index'
  post 'checkout/submit_order'
  get 'checkout/thank_you'
  
  get 'user/new'
  post 'user/create'
  get 'user/show'
  get 'user/show/:id' => 'user#show'
  get 'user/edit'
  post 'user/update'

  get 'forum/post'
  post 'forum/create'
  get 'forum/reply'
  get 'forum/destroy'
  post 'forum/destroy'
  get 'forum/show'
  get 'forum/index'

  get 'password_reset/new'
  post 'password_reset/create'
  get 'password_reset/edit'
  post 'password_reset/update'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
