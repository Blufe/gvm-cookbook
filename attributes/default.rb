default[:gvm][:dest]            = "/usr/local"
default[:gvm][:branch]          = "master"
default[:gvm][:versions]        = %w(go1.1.2)
default[:gvm][:default_version] = "go1.1.2"

default[:gvm][:user_installs]        = %w()
default[:gvm][:user_versions]        = %w(go1.1.2)
default[:gvm][:user_default_version] = "go1.1.2"
