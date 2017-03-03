#
# Cookbook:: citius_jenkins
# Recipe:: configure_jenkins
#
# Copyright:: 2017, The Authors, All Rights Reserved.

git node['jenkins']['master']['home'] do
  repository node['dcar_jenkins']['backup_repo']
  revision node['dcar_jenkins']['backup_branch']
  enable_checkout false
  user 'root'
  group 'root'
  notifies :run, 'execute[have jenkins user jenkins folder and see all files]', :delayed
  action :sync
end

execute 'have jenkins user jenkins folder and see all files' do
  command <<-EOH
    chown -R #{node['jenkins']['master']['user']}:#{node['jenkins']['master']['group']} #{node['jenkins']['master']['home']}
    chmod -R 777 #{node['jenkins']['master']['home']}
    EOH
  action :nothing
end