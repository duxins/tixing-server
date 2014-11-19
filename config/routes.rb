Rails.application.routes.draw do
  namespace :service do
    get 'weibo', to: 'weibo#index'

    # Weibo
    get 'weibo/following',        to: 'weibo#following'
    put 'weibo/following/:name',  to: 'weibo#follow'
    delete 'weibo/following/:id', to: 'weibo#unfollow'

    # V2EX
    get 'v2ex', to: 'v2ex#index'
    post 'v2ex', to: 'v2ex#create'
    delete 'v2ex/:id', to: 'v2ex#destroy'

    # 网易新闻
    resources :netease, except: [:new, :show]

  end

  mount APIv1::API => '/'
end

