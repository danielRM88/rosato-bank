Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users
  resources :accounts
  post 'auth_user' => 'user_tokens#create'
end
