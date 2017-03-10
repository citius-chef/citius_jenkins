#
# Cookbook:: citius_jenkins
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
 
windows_user = data_bag_item('pipeline', 'jenkins_admin')
 
master_tag = node['citius_jenkins']['master_tag']
 
# finding the master from chef server
query = ' tags:"' + master_tag + '"'
log('searching for slave nodes with query :' + query)
master_node = search(:node, query)
master_tags = []

if master_node.length == 1
	log(master_node.length.to_s + ' master node found')    
    master_tags = master_node[0]['tags']
	master = node['citius_jenkins']['master']
	slavename = node['citius_jenkins']['slave_name']

	if (master_tags.include? "slave@#{slavename}")
		if node['platform'] == 'rhel' || node['platform'] == 'redhat' || node['platform'] == 'centos'
		  directory node['citius_jenkins']['service_dir']
		  master_jnlp_url = 'http://' + master + '/computer/' + slavename + '/slave-agent.jnlp'

		  slave_path = "#{node['citius_jenkins']['service_dir']}/slave.jar"
		  cookbook_file slave_path do
			source 'slave.jar'
		  end

		  startup_script = slavename + '_jenkins_slave_startup.sh'
		  template "#{node['citius_jenkins']['service_dir']}/" + startup_script do
			source 'slave_startup.sh.erb'
			mode '0744'
			variables(url: master_jnlp_url,
					  slave_path: slave_path)
		  end

		  template "/etc/init.d/#{startup_script}" do
			source 'slave_startup.sh.erb'
			mode '0777'
			variables(url: master_jnlp_url,
					  slave_path: slave_path)
		  end

		  dir  = node['citius_jenkins']['service_dir']
		  log  = node['citius_jenkins']['log_file']
		  execute 'installing the service' do
			command "nohup #{dir}/" + startup_script + " >#{log} 2>&1 < #{log} &"
			cwd node['citius_jenkins']['service_dir']
			not_if 'ps -eaf|grep [j]enkins'
		  end

		  ruby_block 'wait for service to install' do
			block do
			  sleep(30)
			  text = `cat #{log}`
			  if text.include? 'INFO: Connected'
				puts 'jenkins slave service is running'
			  else
				puts "jenkins slave service is NOT running. please look out the log file for more info (#{log})"
				puts text
				exit 100
			  end
			end
		  end
		elsif node['platform'] == 'windows'
		  user windows_user['username'] do
			password windows_user['password']
		  end

		  group "Administrators" do
			members windows_user['username']
			append true
			action :modify
		  end
		  
		  ruby_block 'set jenkins master details' do
			block do
			  node.default['jenkins']['master']['host'] = master
			  node.default['jenkins']['master']['port'] = 80
			  node.default['jenkins']['master']['endpoint'] = "http://#{node['jenkins']['master']['host']}:#{node['jenkins']['master']['port']}"			  
			  node.save
			end
		  end

		  directory node['citius_jenkins']['service_dir']
		  
		  jenkins_windows_slave slavename do
            remote_fs node['citius_jenkins']['service_dir']
            user windows_user['username']
            password windows_user['password']
			labels [node['slave_labels']]
          end
		  
		  log('slave_labels : ' + node['slave_labels'])
		end
	end
end