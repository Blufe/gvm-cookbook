root_path = node['gvm']['root_path']

%w(curl git mercurial make binutils bison gcc).each do |pkg|
  package pkg do
    action :install
  end
end

git "#{root_path}" do
  repository "git@github.com:moovweb/gvm.git"
  reference "master"
  enable_submodules true
  action :sync
end

%w(environments pkgsets/system/global megos/system).each do |dir|
  directory "#{root_path}/#{dir}" do
    owner "root"
    group "root"
    mode "0755"
    recursive true
    action :create
  end
end

template "/etc/profile.d/gvm.sh" do
  source "gvm.sh.erb"
  owner "root"
  group "root"
  mode "0755"
end

template "#{root_path}/environments/system" do
  source "system.erb"
  owner "root"
  group "root"
  mode "0755"
end

template "#{root_path}/scripts/gvm" do
  source "gvm.erb"
  owner "root"
  group "root"
  mode "0755"
end

bash "mv .git dir" do
  code <<-EOF
    mv /usr/local/gvm/.git /usr/local/gvm/git.bak
  EOF
  only_if { ::File.exists?("/usr/local/gvm/.git") }
end

node['gvm']['versions'].each do |version|
  bash "install #{version}" do
    code <<-EOF
      source /usr/local/gvm/scripts/gvm
      #{root_path}/bin/gvm install #{version}
    EOF
  end
end
