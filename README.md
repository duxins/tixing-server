# Tixing Server

This is the source code of backend server for the [消息提醒] (https://itunes.apple.com/us/app/xiao-xi-ti-xing/id933267052?l=zh&ls=1&mt=8) app.

## TRY IT OUT

### Step 1: Install Prerequisites

* ruby 2.0 +
* redis-server
* MySQL
* node.js
* libmysqlclient-dev
* libcurl3-dev

##### Ubuntu:

```shell
$ sudo apt-get install mysql-server
$ sudo apt-get install redis-server   
$ sudo apt-get install nodejs
$ sudo apt-get install libmysqlclient-dev
$ sudo apt-get install libcurl3-dev
```

##### Mac OS:

```shell
$ brew install redis-server
$ brew install node
$ brew install mysql  
```

### Step 2: Clone Git Repo

```shell
$ git clone git@github.com/duxins/tixing-server
$ cd tixing-server
$ bundle install
```

### Step 3: Setup Config Files
```
$ cp config/{database.yml.example,database.yml}
$ vi config/database.yml
```

Create the database
```shell
$ bundle exec rake db:setup
```

### Step 4: Run the  Server

```shell
# start redis
$ redis-server

# start sidekiq
$ bundle exec sidekiq

$ rails s
```