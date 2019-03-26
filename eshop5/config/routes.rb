Rails.application.routes.draw do
  
  root :to => 'about#index'

  get 'about' => 'about#index'
  get 'admin/director' => 'admin/director#index'
  get 'admin/producer' => 'admin/producer#index'

  get 'about/index'
  
  get 'admin/producer/new'
  post 'admin/producer/create'
  get 'admin/producer/edit'
  post 'admin/producer/update'
  post 'admin/producer/destroy'
  get 'admin/producer/show'
  get 'admin/producer/show/:id' => 'admin/producer#show'
  get 'admin/producer/index'

  get 'admin/director/new'
  post 'admin/director/create'
  get 'admin/director/edit'
  post 'admin/director/update'
  post 'admin/director/destroy'
  get 'admin/director/show'
  get 'admin/director/show/:id' => 'admin/director#show'
  get 'admin/director/index'  
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
