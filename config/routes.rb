Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: 'welcome#index'

  namespace :service do
    # Weibo
    get 'weibo', to: 'weibo#index'
    put 'weibo/following/:name',  to: 'weibo#follow'
    delete 'weibo/following/:id', to: 'weibo#unfollow'

    # V2EX
    get 'v2ex', to: 'v2ex#index'
    post 'v2ex', to: 'v2ex#create'
    delete 'v2ex/:id', to: 'v2ex#destroy'

    # 网易新闻
    resources :netease, except: [:new, :show]

    # 京东降价提醒
    resources :jingdong, except: [:new, :show]
    get 'jingdong/search/:id', to: 'jingdong#search'

    # 顺丰优选
    resources :shunfeng, except: [:new, :show]
    get 'shunfeng/search/:id', to: 'shunfeng#search'

  end

  mount APIv1::API => '/'
end

