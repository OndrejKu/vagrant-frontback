# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version '>= 1.5'

# Change these two paths to folders 
FRONTEND  = "../linkip-frontend/"
BACKEND   = "../linkip-backend/"

def require_plugins(plugins = {})
  needs_restart = false
  plugins.each do |plugin, version|
    next if Vagrant.has_plugin?(plugin)
    cmd =
      [
        'vagrant plugin install',
        plugin
      ]
    cmd << "--plugin-version #{version}" if version
    system(cmd.join(' ')) || exit!
    needs_restart = true
  end
  exit system('vagrant', *ARGV) if needs_restart
end

require_plugins \
  'vagrant-bindfs' => '0.4.8', 
  'vagrant-librarian-chef-nochef' => '0.2.0', 
  'vagrant-vbguest' => '0.12.0' 

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 3000, host: 3000 
  config.vm.network "forwarded_port", guest: 4567, host: 4567

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  config.vm.synced_folder ".", "/project/#{}",
    # Tell Vagrant to use rsync for this shared folder.
    type: "rsync",
    rsync__auto: "true",
    rsync__exclude: ".git/",
    owner: "vagrant",
    group: "vagrant",
    id: "shared-folder-id"

  # Use Chef Solo to provision our virtual machine
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks", "site-cookbooks"]

    chef.add_recipe "apt"
    chef.add_recipe "nodejs"
    chef.add_recipe "ruby_build"
    chef.add_recipe "rbenv::user"
    chef.add_recipe "rbenv::vagrant"
    chef.add_recipe "vim"
    chef.add_recipe "mysql::server"
    chef.add_recipe "mysql::client"

    # Install Ruby 2.2.3 and Bundler
    # Set an empty root password for MySQL to make things simple
    chef.json = {
      rbenv: {
        user_installs: [{
          user: 'vagrant',
          rubies: ["2.2.3"],
          global: "2.2.3",
          gems: {
            "2.2.3" => [
              { name: "bundler" }
            ]
          }
        }]
      },
      mysql: {
        server_root_password: ''
      }
    }
  end
end
