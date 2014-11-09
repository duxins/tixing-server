Rails.application.routes.draw do
  namespace :service do
    get 'weibo', to: 'weibo#index'

    get 'weibo/following',        to: 'weibo#following'
    put 'weibo/following/:name',  to: 'weibo#follow'
    delete 'weibo/following/:id', to: 'weibo#unfollow'

    get 'v2ex', to: 'v2ex#index'
    post 'v2ex', to: 'v2ex#create'
    delete 'v2ex/:id', to: 'v2ex#destroy'

  end

  mount APIv1::API => '/'
end

