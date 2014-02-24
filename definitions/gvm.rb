define :gvm, :user => nil,
                   :group => nil,
                   :gvm_dest => nil,
                   :gvm_branch => nil,
                   :go_versions => nil,
                   :install_vet => nil,
                   :install_godoc => nil,
                   :default_go_version => nil do
  user = params[:user]
  group = params[:group]
  gvm_dest = params[:gvm_dest]
  gvm_branch = params[:gvm_branch]
  go_versions = params[:go_versions]
  install_vet = params[:install_vet]
  install_godoc = params[:install_godoc]
  default_go_version = params[:default_go_version]
  home = user == "root" ? "/root" : "/home/#{user}"
  gvm_root = gvm_dest ? "#{gvm_dest}/gvm" : "#{home}/.gvm" 

  bash "install GVM" do
    user user
    group group
    environment 'HOME' => home
    code <<-SH
      curl -s https://raw.github.com/moovweb/gvm/master/binscripts/gvm-installer -o /tmp/gvm-installer &&
      bash /tmp/gvm-installer #{gvm_branch} #{gvm_dest}
      rm   /tmp/gvm-installer
    SH
    not_if { File.exists?("#{gvm_root}") }
  end

  go_versions.each do |version|
    bash "installing #{version}" do
      user user
      group group
      environment 'HOME' => home, 'GVM_ROOT' => gvm_root
      code "source #{gvm_root}/scripts/gvm && gvm install #{version}"
      not_if { File.exists?("#{gvm_root}/gos/#{version}") }
    end

    if install_vet && version.slice(/\d+\.\d+/).to_f >= 1.2
      bash "installing vet to #{version}" do
        user user
        group group
        environment 'HOME' => home, 'GVM_ROOT' => gvm_root
        code <<-EOH
          source #{gvm_root}/scripts/gvm
          gvm use #{version}
          go get code.google.com/p/go.tools/cmd/vet
        EOH
      end
    end

    if install_godoc && version.slice(/\d+\.\d+/).to_f >= 1.2
      bash "installing godoc to #{version}" do
        user user
        group group
        environment 'HOME' => home, 'GVM_ROOT' => gvm_root
        code "source #{gvm_root}/scripts/gvm && gvm use #{version} && go get code.google.com/p/go.tools/cmd/godoc"
      end
    end
  end

  if default_go_version
    bash "setup default go version to #{default_go_version}" do
      user user
      group group
      environment 'HOME' => home, 'GVM_ROOT' => gvm_root
      code "source #{gvm_root}/scripts/gvm && gvm use #{default_go_version} --default"
    end
  end

  template "/etc/profile.d/gvm.sh" do
    source "gvm.sh.erb"
    owner "root"
    group "root"
    mode "0755"
    variables(
      :gvm_root => gvm_dest ? "#{gvm_dest}/gvm" : "$HOME/.gvm"
    )
  end
end
