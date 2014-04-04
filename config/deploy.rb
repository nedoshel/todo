# -*- coding: utf-8 -*-
require "rvm/capistrano"
require "bundler/capistrano"
#require 'capistrano/nginx/tasks'

ssh_options[:forward_agent] = true
ssh_options[:port] = 22

set :rails_env,   "production"
set :app_env,     "production"

set :app_port, 80

set :rvm_ruby_string, "ruby-2.0.0-p353"
#set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,'')

set :rvm_type, :user

set :default_shell, :bash

default_run_options[:pty] = true
set :repository, "git@github.com:nedoshel/todo.git"
set :scm, "git"


set :branch, 'master'

set :application, "todo"

set :deploy_to, "/var/www/todo"

set :thin_config, "config/thin/#{application}.yml"


#set :server_name, "todo.muravkin.tk"
set :sudo_user, :deploy

server '162.243.21.109', :app, :web, :db, primary: true

set :scm_verbose, true

set :user, "deploy"

set :rvm_bin_path, " /home/#{user}/.rvm/bin/"

set :use_sudo, false
set :keep_releases, 2


set :bundle_cmd, "/home/#{user}/.rvm/gems/#{rvm_ruby_string}@global/bin/bundle"

before 'deploy:migrate', 'deploy:symlink_shared'
after 'deploy:symlink_shared', 'deploy:create_db'
before 'deploy:assets:precompile', 'deploy:migrate'
after 'deploy', 'deploy:cleanup'


namespace :deploy do
  desc "Restart Thin"
  task :restart, :except => { :no_release => true } do
    run "cd #{current_path} ; RAILS_ENV=#{rails_env} #{bundle_cmd} exec thin restart -C #{thin_config}"
  end

  desc "Start Thin"
  task :start, :except => { :no_release => true } do
    run "cd #{current_path} ; RAILS_ENV=#{rails_env} #{bundle_cmd} exec thin start -C #{thin_config}"
  end

  desc "Stop Thin"
  task :stop, :except => { :no_release => true } do
    run "cd #{current_path} ; RAILS_ENV=#{rails_env} #{bundle_cmd} exec thin stop -C #{thin_config}"
  end

  task :symlink_shared, :except => { :no_release => true } do
    run "mkdir -p #{shared_path}/uploads"
    run "mkdir -p #{shared_path}/assets"
    run "mkdir -p #{shared_path}/log"

    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
    run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
    run "ln -nfs #{shared_path}/log #{release_path}/log"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  task :create_db do
     run "cd #{release_path} && bundle exec rake db:create RAILS_ENV=production"
  end

  task :create_admin do
     run "cd #{release_path} && bundle exec rake admin:create RAILS_ENV=production"
  end

end


namespace :cache do

  task :clear do
    run " cd #{deploy_to}/current && bundle exec rake tmp:cache:clear RAILS_ENV=production"
  end

end
