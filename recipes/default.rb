#
# Cookbook:: citius_jenkins
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'sudo'
include_recipe 'java'
include_recipe 'git'
include_recipe 'citius_jenkins::configure_iptables'
include_recipe 'citius_jenkins::create_netrc'
include_recipe 'citius_jenkins::configure_jenkins' if node['citius_jenkins']['deploy_backup']
include_recipe 'jenkins::master'
tag('master')