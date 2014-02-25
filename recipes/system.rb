include_recipe 'gvm::_package'

gvm do
  user 'root'
  group 'root'
  gvm_dest node[:gvm][:dest]
  gvm_branch node[:gvm][:branch]
  go_versions node[:gvm][:versions]
  install_vet node[:gvm][:install_vet]
  install_godoc node[:gvm][:install_godoc]
  default_go_version node[:gvm][:default_version]
end
