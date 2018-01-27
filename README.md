# README

* Ruby version
  * 2.4.1

* Rails version
  * 5.1.3

* System dependencies
  * MariaDB 10.1.25

* Gems

  ```bash
  #--------------------------------------------------------------
  #  Extra Gems
  #--------------------------------------------------------------
  # Auth
  gem 'devise'
  gem 'cancancan'
  gem 'rolify'

  # Omniauth with facebook
  gem 'omniauth-facebook'

  # Pretty URL
  gem 'friendly_id'
  # Pretty URL for non english string
  gem 'babosa'

  # pagination
  gem 'kaminari'
  
  # Beautiful routes (like pretty pagination
  gem 'routing-filter'
  ```

* Yarn
  * jquery
  * bootstrap
  * font-awesome

* devise + cancancan + rolify 
  * Reference
    * https://github.com/RolifyCommunity/rolify/wiki/Devise---CanCanCan---rolify-Tutorial
  * Gem
    * gem 'devise'
    * gem 'cancancan'
    * gem 'rolify'
  * Command
    * bundle exec rails g devise:install
    * Modify the recommendation

      ```
      config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
      In production, :host should be set to the actual host of your application.
      ```

      ```
      root to: "home#index"
      ```

      ```
      <p class="notice"><%= notice %></p>
      <p class="alert"><%= alert %></p>
      ```

    * bundle exec rais g devise User
    * bundle exec rais g devise:views
    * bundle exec rais g cancan:ability
    * bundle exec rais g rolify Role User (Check the following)
  * Configuration
    * add rolify controll into model you want to

      ```
      class Forum < ActiveRecord::Base
        resourcify
      end
      ```

    * Before db migration
      * Add migration version to avoid error

        ```
        class RolifyCreateRoles < ActiveRecord::Migration[5.1]>
        ```

    * Edit devise_omniauth/app/models/ability.rb as below
      * https://github.com/charlietag/devise_omniauth/blob/master/app/models/ability.rb

    * Add load_and_authorize_resource as below
      * https://github.com/charlietag/devise_omniauth/blob/master/app/controllers/articles_controller.rb

* Friendly ID
  * Reference
    * https://github.com/norman/friendly_id
  * Gem
    * gem 'friendly_id'
    * gem 'babosa' # for non-english language
  * Command
    * bundle exec rails g friendly_id
    * bundle exec rails g migration AddSlugToArticle slug:string:uniq
    * Before db migration
      * Add migration version to avoid error

        ```
        class RolifyCreateRoles < ActiveRecord::Migration[5.1]>
        ```

  * Configuration
    * Model: devise_omniauth/app/models/article.rb
      * https://github.com/charlietag/devise_omniauth/blob/master/app/models/article.rb
    * Controller: no need to change , using finder in model above

* Kaminari
  * Reference
    * https://github.com/kaminari/kaminari
  * Gem
    * gem 'kaminari'
  * Command
    * bundle exec rails g kaminari:config # Add only main pagination config
  * Configuration
    * Controller
      * https://github.com/charlietag/devise_omniauth/blob/master/app/controllers/articles_controller.rb
        
        ```
        @articles = Article.includes(:user).page params[:page]
        ```

    * View
      * https://github.com/charlietag/devise_omniauth/blob/master/app/views/articles/index.html.erb
      
        ```
        <%= paginate @articles %>
        ```

* Customized yaml config file
  * https://github.com/charlietag/devise_omniauth/blob/master/config/application.rb
  
    ```
    # My Custom yaml config
    config.myconfig = config_for(:myconfig)
    ```

  * myconfig.yml
    * https://github.com/charlietag/devise_omniauth/blob/master/config/myconfig.yml.sample

* routing-filter
  * Ref
    * https://github.com/svenfuchs/routing-filter/tree/master
  * Gem
    * gem 'routing-filter'
  * Usage

    ```
    # in config/routes.rb
    Rails.application.routes.draw do
      filter :pagination, :uuid
    end
    ```

* omniauth-facebook
  * Reference
    * https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview
  * Goto Facebook setup
    * https://developers.facebook.com/
  * Gem
    * gem 'omniauth-facebook'
  * Command
    * bundle exec rails g migration AddOmniauthToUsers provider:string uid:string name:string fblink:text picture:text
  * Configuration
    * devise_omniauth/config/initializers/devise.rb
      * https://github.com/charlietag/devise_omniauth/blob/master/config/initializers/devise.rb
        
        ```
        myconfig = Rails.configuration.myconfig
        config.omniauth :facebook, myconfig['fb_app_id'], myconfig['fb_app_secret'], 
                                   scope: 'email',
                                   info_fields: 'email, name, link',
                                   secure_image_url: true,
                                   image_size: "large"
        ```

    * Routes
      * https://github.com/charlietag/devise_omniauth/blob/master/config/routes.rb

        ```
        devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
        ```

    * Model
      * https://github.com/charlietag/devise_omniauth/blob/master/app/models/user.rb

          ```
          :omniauthable, :omniauth_providers => [:facebook]
          ```

          ```
          # omniauth-facebook
          def self.from_omniauth(auth)
            where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
              user.email = auth.info.email
              user.password = Devise.friendly_token[0,20]
              #user.provider = auth.provider  # automatically set
              #user.uid = auth.uid  # automatically set
              user.name = auth.info.name
              user.fblink = auth.info.urls.Facebook
              user.picture= auth.info.image # assuming the user model has an image
              # If you are using confirmable and the provider(s) you use validate emails, 
              # uncomment the line below to skip the confirmation emails.
              # user.skip_confirmation!
            end
          end
        
          def self.new_with_session(params, session)
            super.tap do |user|
              if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
                user.email = data["email"] if user.email.blank?
              end
            end
          end
          ```

    * Controller
      * https://github.com/charlietag/devise_omniauth/blob/master/app/controllers/users/omniauth_callbacks_controller.rb

    * View
      * https://github.com/charlietag/devise_omniauth/blob/master/app/views/layouts/application.html.erb
      
        ```
        <%= link_to "Sign in with Facebook", user_facebook_omniauth_authorize_path %>
        ```
