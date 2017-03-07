slave = node['citius_jenkins']['slave_tag']
######################################################
query = ' tags:"' + slave + '"'
log('searching for slave nodes with query :' + query)

slave_nodes = search(:node, query)

if slave_nodes
  log(slave_nodes.length.to_s + ' slave node(s) found')
  log(slave_nodes)
else
  log 'no slave nodes found'
end

jenkins_admin = data_bag_item('pipeline', 'jenkins_user')
ruby_block 'set the service user credentials' do
  block do
    node.run_state[:jenkins_username] = jenkins_admin["username"]
    node.run_state[:jenkins_password] = jenkins_admin["password"]
  end
end

# creating windows slaves in master
slave_nodes.each do |each_slave|	
  node.override['citius_jenkins']['slave_name'] = each_slave['slave_labels'] + '-' + each_slave['platform_family']
  slavename = node['citius_jenkins']['slave_name']
  log(slavename + ' is the slave')
  
  if each_slave['slave_labels'] == 'build-server'
    executor = 3
  else
    executor = 1
  end

  if each_slave['slave_labels'] == 'test-server'
    remote_fs = 'c:\\jenkins_service'
  else 
    remote_fs = slave['remote_jenkins_dir']
  end
  
  slave = node['citius_jenkins']['slaves']

  jenkins_slave slavename do
    description      slave['description'] if slave['description']
    remote_fs        remote_fs
    executors        executor
    usage_mode       slave['usage_mode'] if slave['usage_mode']
    availability     slave['availability'] if slave['availability']
    in_demand_delay  slave['idle_delay'] if slave['idle_delay']
    idle_delay       slave['idle_delayname'] if slave['idle_delayname']
    user             slave['user'] if slave['user']
    labels           [each_slave['slave_labels']]
  end

tag('slave@' + slavename)
end
