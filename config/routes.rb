Rails.application.routes.draw do
  namespace :service do
    get 'weibo', to: 'weibo#index'
  end

  mount APIv1::API => '/'
end

