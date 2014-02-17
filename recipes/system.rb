include_recipe 'gvm-cookbook::_package'

gvm do
  user 'root'
  group 'root'
  gvm_dest node[:gvm][:dest]
  gvm_branch node[:gvm][:branch]
  go_versions node[:gvm][:versions]
  default_go_version node[:gvm][:default_version]
end
