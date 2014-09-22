require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, 'fitark.org'
set :deploy_to, '/dfs/deploy'
set :repository, 'git@fitark.org:saturn/webadmin.git'
set :branch, 'master'
set :term_mode, :system
# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'log']

# Optional settings:
set :user, 'ubuntu'    # Username in the server to SSH to.
set :port, '8305'     # SSH port number.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  invoke :'rvm:use[ruby-2.0.0-p353]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :launch do
      queue! %[mkdir -p "#{deploy_to}/current/tmp/pids"]
      queue! %[chmod g+rx,u+rwx "#{deploy_to}/current/tmp/pids"]
      queue! %[ln  -s /dfs/pacs/    /home/git/deploy/current/public/]
    end
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers



task :down do
  invoke :maintenance_on
  #invoke :restart
end
task :maintenance_on  do
  #queue 'touch maintenance.txt'
  #杀死 unicorn  重启
  queue! %[  ps aux |grep unicorn|grep -v grep |awk '{print $2}'|xargs kill -9 ]
  queue! %[ unicorn_rails -c "#{deploy_to}/current/config/unicorn.rb -D  -E production" ]
  queue! %[ cd  #{deploy_to}/current; unicorn -c #{deploy_to}/current/config/unicorn.rb -D  -E production]
  queue! %[ curl  localhost:9000 ]

  #queue! %[rainbows config.ru -c "#{deploy_to}/current/config/unicorn.rb -E production -D "]
end


namespace :unicorn do
  set :unicorn_pid, "#{deploy_to}/current/tmp/pids/unicorn.pid"
  set :start_unicorn, %{
    cd #{deploy_to}/current
    unicorn -c #{deploy_to}/current/config/unicorn.rb -E #{rails_env} -D
  }

#                                                                    Start task
# ------------------------------------------------------------------------------
  desc "Start unicorn"
  task :start => :environment do
    queue 'echo "-----> Start Unicorn"'
    queue! start_unicorn
  end

#                                                                     Stop task
# ------------------------------------------------------------------------------
  desc "Stop unicorn"
  task :stop do
    queue 'echo "-----> Stop Unicorn"'
    queue! %{  echo  " tmp pid path is:  #{unicorn_pid}"}
    queue! %[  ps aux |grep unicorn|grep -v grep |awk '{print $2}'|xargs kill -9 ]
    #queue! %{
    #  test -s "#{unicorn_pid}" && kill -QUIT `cat "#{unicorn_pid}"` && echo "Stop Ok" && exit 0
    #  echo >&2 "Not running"
    #}
  end

#                                                                  Restart task
# ------------------------------------------------------------------------------
  desc "Restart unicorn using 'upgrade'"
  task :restart => :environment do
    invoke 'unicorn:stop'
    invoke 'unicorn:start'
  end
end

desc "Shows logs."
task :logs do
  queue %[cd #{deploy_to!} && tail -f shared/log/production.log]
end

