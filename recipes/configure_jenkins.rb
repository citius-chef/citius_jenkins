#
# Cookbook:: citius_jenkins
# Recipe:: configure_jenkins
#
# Copyright:: 2017, The Authors, All Rights Reserved.

git node['jenkins']['master']['home'] do
  repository node['citius_jenkins']['backup_repo']
  revision node['citius_jenkins']['backup_branch']
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

slave_port = node['citius_jenkins']['jnlp_slave_port_in_master']
bash 'change slave agent port num' do
  code <<-EOH
    sed -i.bak 's/<slaveAgentPort>.*<\\\/slaveAgentPort>/<slaveAgentPort>#{slave_port}<\\/slaveAgentPort>/g' /var/lib/jenkins/config.xml
  EOH
  not_if "cat /var/lib/jenkins/config.xml | grep '<slaveAgentPort>#{slave_port}<\\/slaveAgentPort>'"
  notifies :execute, 'jenkins_command[safe-restart]', :immediately
end
