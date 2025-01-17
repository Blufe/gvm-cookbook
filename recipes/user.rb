include_recipe 'gvm::_package'

node[:gvm][:user_installs].each do |user|
  gvm do
    user user
    group user
    gvm_dest nil
    gvm_branch node[:gvm][:branch]
    install_vet node[:gvm][:install_vet]
    install_godoc node[:gvm][:install_godoc]
    go_versions node[:gvm][:user_versions]
    default_go_version node[:gvm][:user_default_version]
  end
end
