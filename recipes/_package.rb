include_recipe "apt"

%w(curl git mercurial make binutils bison gcc).each do |pkg|
  package pkg do
    action :install
  end
end
