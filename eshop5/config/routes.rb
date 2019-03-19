Rails.application.routes.draw do
  
  root :to => 'about#index'

  get 'about' => 'about#index'
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
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end