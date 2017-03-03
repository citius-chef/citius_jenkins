#
# Cookbook:: citius_jenkins
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
 
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
		  end

		  ruby_block 'wait for service to install' do
			block do
			  sleep(150)
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
		end
	end
end