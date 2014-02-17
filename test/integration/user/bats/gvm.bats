#!/usr/bin/env bats

gvm_root="/home/vagrant/.gvm"
go_version="go1.1.2"
default_go_version="go1.1.2"

setup() {
  source /etc/profile.d/gvm.sh
}

@test "profile.d file" {
  [ -f "/etc/profile.d/gvm.sh" ]
}

@test "gvm version" {
  run env
  echo $output
  run gvm version
  [ $status -eq 0 ]
  [ $(echo "$output" | grep -o $gvm_root) = "$gvm_root" ]
}

@test "go version" {
  run gvm list
  echo $output
  [ $status -eq 0 ]
  [ $(echo "$output" | grep "=>") = "=> $go_version" ]

  run go version
  [ $status -eq 0 ]
  [ $(echo "$output" | grep -o "$go_version") = "$go_version" ]
}

@test "go env" {
  run go env
  echo $output
  [ $status -eq 0 ]
  [ $(echo "$output" | grep "GOROOT") = "GOROOT=\"$gvm_root/gos/$go_version\"" ]
  [ $(echo "$output" | grep "GOPATH") = "GOPATH=\"$gvm_root/pkgsets/$go_version/global\"" ]
}

@test "[normal user] go get github.com/codegangsta/cli" {
  run go get github.com/codegangsta/cli
  [ $status -eq 0 ]
}

@test "[normal user] gvm install go1.2" {
  run gvm install go1.2
  [ $status -eq 0 ]
  
  run gvm list
  [ $status -eq 0 ]
  [ $(echo "$output" | grep -o "go1.2") = "go1.2" ]
  
  run gvm use go1.2 --default && source /etc/profile.d/gvm.sh
  echo $output
  [ $status -eq 0 ]
  
  run go version
  echo $output
  [ $status -eq 0 ]
  echo "$output"
  [ $(echo "$output" | grep -o "go1.2") = "go1.2" ]
  
  run gvm uninstall go1.2
  echo $output
  [ $status -eq 0 ]
  
  run gvm use $go_version --default && source /etc/profile.d/gvm.sh
  echo $output
  [ $status -eq 0 ]
}

teardown() {
  rm -fr $gvm_root/pkgsets/$go_version/global/src/*
}
