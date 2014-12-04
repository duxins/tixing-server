# 微博
every 5.minutes do
  rake 'weibo:run'
end

# 清理没人关注的微博用户
every 2.hours do
  rake 'weibo:cleanup'
end

# V2EX
every 3.minutes do
  rake 'v2ex:run'
end


# 网易新闻
every 3.minutes do
  rake 'netease:run[high]'
end

every 10.minutes do
  rake 'netease:run[medium]'
end

# 京东价格抓取
every 1.hour do
  rake 'jingdong:run'
end

# 清理京东商品
every 1.day, :at => '4:30 am' do
  rake 'jingdong:cleanup'
end

# 顺丰优选
every 80.minutes do
  rake 'shunfeng:run'
end

# 清理顺丰商品
every 1.day, :at => '5:30 am' do
  rake 'shunfeng:cleanup'
end
