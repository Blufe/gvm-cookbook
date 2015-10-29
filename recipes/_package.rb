case node["platform"]

when "debian", "ubuntu"
  include_recipe "apt"

  %w(curl git mercurial make binutils bison gcc).each do |pkg|
    package pkg do
      action :install
    end
  end

when "redhat", "centos", "fedora", "amazon"
  %w(curl git make bison gcc glibc-devel).each do |pkg|
    package pkg do
      action :install
    end
  end
end
