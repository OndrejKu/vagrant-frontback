include_recipe "ruby_rbenv"

rbenv_script "install_backend" do
  rbenv_version "2.2.1"
  user          "vagrant"
  group         "vagrant"
  cwd           "/project/linkip-backend"
  code          %{rbenv rehash && bundle install && bundle exec rake db:setup && bundle exec rake db:seed_fu}
end

rbenv_script "run_server" do
	rbenv_version "2.2.1"
	user          "vagrant"
	group         "vagrant"
	cwd           "/project/linkip-backend"
	code          %{bundle exec rails s -b 0.0.0.0 -d}
end	