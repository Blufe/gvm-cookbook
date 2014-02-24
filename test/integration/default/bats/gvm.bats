#!/usr/bin/env bats

gvm_root="/usr/local/gvm"
go_version="go1.2"

setup() {
  source /etc/profile.d/gvm.sh
}

@test "profile.d file" {
  [ -f "/etc/profile.d/gvm.sh" ]
}

@test "gvm version" {
  run gvm version
  [ $status -eq 0 ]
  [ $(echo "$output" | grep -o $gvm_root) = "$gvm_root" ]
}

@test "go version" {
  run gvm list
  [ $status -eq 0 ]
  [ $(echo "$output" | grep "=>") = "=> $go_version" ]

  run go version
  [ $status -eq 0 ]
  [ $(echo "$output" | grep -o "$go_version") = "$go_version" ]
}

@test "go env" {
  run go env
  [ $status -eq 0 ]
  [ $(echo "$output" | grep "GOROOT") = "GOROOT=\"$gvm_root/gos/$go_version\"" ]
  [ $(echo "$output" | grep "GOPATH") = "GOPATH=\"$gvm_root/pkgsets/$go_version/global\"" ]
}

@test "check vet" {
  run go tool
  [ $status -eq 0 ]
  [ $(echo "$output" | grep -o "vet") = "vet" ]
}

@test "check godoc" {
  run godoc fmt
  [ $status -eq 0 ]
}

@test "[normal user] go get github.com/codegangsta/cli" {
  run sudo -u vagrant env PATH=$PATH GOPATH=$GOPATH go get github.com/codegangsta/cli
  [ $status -ne 0 ]
  [ $(echo "$output" | grep -o "permission denied") = "permission denied" ]
}

@test "[super user] go get github.com/codegangsta/cli" {
  run sudo -u root env PATH=$PATH GOPATH=$GOPATH go get github.com/codegangsta/cli
  [ $status -eq 0 ]
}

@test "[normal user] gvm install go1.1.1" {
  run sudo -u vagrant env PATH=$PATH GVM_ROOT=$GVM_ROOT gvm install go1.1.1
  [ $status -ne 0 ]
  [ $(echo "$output" | grep -o "Permission denied") = "Permission denied" ]
}

@test "[super user] gvm install go1.1.1" {
  run sudo -u root env PATH=$PATH GVM_ROOT=$GVM_ROOT gvm install go1.1.1
  [ $status -eq 0 ]
  
  run gvm list
  [ $status -eq 0 ]
  [ $(echo "$output" | grep -o "go1.1.1") = "go1.1.1" ]
  
  run gvm use go1.1.1 --default && source /etc/profile.d/gvm.sh
  [ $status -eq 0 ]
  
  run go version
  [ $status -eq 0 ]
  [ $(echo "$output" | grep -o "go1.1.1") = "go1.1.1" ]
  
  run sudo -u root env PATH=$PATH GVM_ROOT=$GVM_ROOT gvm uninstall go1.1.1
  [ $status -eq 0 ]
  
  run gvm use $go_version --default && source /etc/profile.d/gvm.sh
  [ $status -eq 0 ]
}

teardown() {
  rm -fr $gvm_root/pkgsets/$go_version/global/src/*
}
