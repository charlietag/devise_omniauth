Rails.application.routes.draw do
  resources :articles do
    resources :comments
  end
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #root to: "home#index"
  #root to: redirect('/home')
  root to: "articles#index"

end
