require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'mina_sidekiq/tasks'
require 'mina/whenever'

set :domain, 'web.tixing'
set :user,   'deploy'
set :deploy_to, '/var/www/tixing'
set :repository, 'git@github.com:duxins/tixing-server.git'
set :branch, 'master'
set :rpush_pid_file, "#{deploy_to}/#{shared_path}/tmp/rpush.pid"

set :shared_paths, [
    'config/database.yml',
    'config/application.yml',
    'config/newrelic.yml',
    'config/apn_certificate.pem',
    'config/initializers/rack-attack.rb',
    'tmp',
    'log',
]

task :environment do
   invoke :'rvm:use[ruby-2.1.4]'
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/pids"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/tmp"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/application.yml"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'sidekiq:quiet'
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
      invoke :'rpush:reload'
      invoke :'whenever:update'
      invoke :'sidekiq:restart'
    end
  end
end

namespace :rpush do
  task :reload => :environment do
    queue %[echo "-----> Reload rpush"]
    queue %{
        if [ -f #{rpush_pid_file} ]; then
          kill -s HUP `cat #{rpush_pid_file}`
        else
          echo 'No pid file found'
        fi
      }
  end

  task :start => :environment do
    queue %[echo "-----> Start rpush"]
    queue %{
      cd "#{deploy_to}/#{current_path}"
      #{echo_cmd %[bundle exec rpush start] }
    }
  end
end
