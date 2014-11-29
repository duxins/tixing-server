# 微博
every 5.minutes do
  rake 'weibo:run'
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

