# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'recipe'
set :repo_url, ENV["GIT_REPO"]
set :deploy_to, ENV["PROJECT_PATH"]
# set :project_root_path, File.dirname(File.expand_path('../',__FILE__))
set :project_root_path, ENV['CURRENT_PATH']

set :user, ENV["USER_NAME"]
set :use_sudo, false
set :rbenv_ruby, "2.2.2"
set :rbenv_path, "#{ENV['USER_HOME']}/.rbenv"
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w(rake gem bundle ruby rails)
set :rbenv_roles, :all 
# set:rails_env, :production
# set :using_rvm, false   # using rbenv
set :rbenv_type, :user
set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"
set :default_env, { path: "~/.rbenv/shims:~/.rbenv/bin:$PATH" }
set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$HOME/bin:$HOME/local/bin:$PATH"
}

namespace :mongodb do
  desc "Install the latest stable release of Mongodb."
  task :install do
    on roles(:web) do
      execute "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10"
      execute "sudo touch /etc/apt/sources.list.d/10gen.list"
      execute "sudo echo 'deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse' | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list"
      execute "sudo echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list"
      execute "sudo apt-get -y update"
      execute "sudo apt-get install -y mongodb-org"
      execute "sudo service mongod start"
    end
  end
end

namespace :system do
  task :set_locale do
    on roles(:web) do
      execute "export LANGUAGE=en_US.UTF-8"
      execute "export LANG=en_US.UTF-8"
      execute "export LC_ALL=en_US.UTF-8"
      execute "sudo locale-gen en_US.UTF-8"
      execute "sudo dpkg-reconfigure locales"
    end
  end

  task :install_zsh do
    on roles(:web) do
      # execute "sudo apt-get install zsh git-core", raise_on_non_zero_exit: false
      # execute "git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh", raise_on_non_zero_exit: false
      # execute "wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh", raise_on_non_zero_exit: false
      # execute "chsh -s `which zsh`", raise_on_non_zero_exit: false
      # upload! "./.zshrc", "#{ENV['HOME']}", raise_on_non_zero_exit: false
      execute "wget https://raw.githubusercontent.com/bobthecow/git-flow-completion/master/git-flow-completion.zsh"
      upload! "#{fetch(:project_root_path)}/.zshrc", "#{ENV['USER_HOME']}"
      upload! "#{fetch(:project_root_path)}/.aliases", "#{ENV['USER_HOME']}"
    end
  end

  task :install_pyenv do
    on roles(:web) do
      # upload! "#{fetch(:project_root_path)}/pyenv_install.sh", "#{ENV['HOME']}", raise_on_non_zero_exit: false
    end
  end

  task :test do
    on roles(:web) do
      # execute "touch hihihi 2015-10-07"
    end
  end
end

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

# after 'deploy:published', 'mongodb:install'
# after 'deploy:published', 'system:test'
# after 'deploy:published', 'system:set_locale'
after 'deploy:published', 'system:install_zsh'