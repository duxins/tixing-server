Rails.application.routes.draw do
  namespace :service do
    get 'weibo', to: 'weibo#index'

    get 'weibo/following',        to: 'weibo#following'
    put 'weibo/following/:name',  to: 'weibo#follow'
    delete 'weibo/following/:id', to: 'weibo#unfollow'
  end

  mount APIv1::API => '/'
end

