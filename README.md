gvm Cookbook
============
Manage go versions with [gvm](https://github.com/moovweb/gvm).


Requirements
------------
Only tested on Ubuntu 12.04 :p


Attributes
----------
* `node[:gvm][:root_path]`
    - Install path of gvm (Default: /usr/local/gvm).

* `node[:gvm][:versions]`
    - Install go version (Default: go1.1.2).

Recipes
-------
### default
Install go with gvm.

Usage
-----
Put `recipe[gvm]` in the run list.
