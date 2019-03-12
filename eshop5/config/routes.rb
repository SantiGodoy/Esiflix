Rails.application.routes.draw do
  root :to => 'about#index'

  get 'about' => 'about#index'
  
  get 'about/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
