Rails.application.routes.draw do
  #routing filter to pretty paginations
  filter :pagination

  #resources :comments
  resources :articles do
    resources :comments
  end
  #devise_for :users
  #devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" } # old ruby way
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" } # new ruby way

  # NO NEED to setup the following , it's set by devise default
  #devise_scope :user do
  #  delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  #end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #root to: "home#index"
  #root to: redirect('/home')
  root to: "articles#index"

end
