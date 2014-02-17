# gvm Cookbook

Manage go versions with [gvm](https://github.com/moovweb/gvm).


## Requirements
### Platform

* ubuntu (12.04)

## Recipes
### default

This recipe includes system recipe.


### system

Installs the gvm codebase system-wide (that is, into /usr/local/gvm). 


### user

Installs the gvm codebase for a list of users (selected from the node['gvm']['user_installs'] hash).


## Attributes

* `node[:gvm][:dest]`
    - Destination directory of gvm (Default: /usr/local).

* `node[:gvm][:branch]`
    - GVM branch (Default: master).

* `node[:gvm][:versions]`
    - A list of system-wide golang to be built and installed.

* `node[:gvm][:default_version]`
    - Default go version.

* `node[:gvm][:user_installs]`
    - A list of user to be installed gvm (Default: empty).

* `node[:gvm][:user_versions]`
    - A list of golang to be built and installed.

* `node[:gvm][:user_default_version]`
    - Default go version.
