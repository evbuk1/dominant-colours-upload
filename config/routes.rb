Rails.application.routes.draw do
  use_doorkeeper
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :v1 do
    scope module: :users do
      resources :users
    end
  end
end
