default['java']['jdk_version'] 				= '8'
default['citius_jenkins']['deploy_backup']  = true
default['citius_jenkins']['backup_branch']    = 'master'
default['citius_jenkins']['backup_repo']      = 'https://github.com/pratikghodekar/jenkins_backup.git'
default['citius_jenkins']['service_dir']      = if node['platform_family'] == 'windows'
												'c:\jenkins_slave'
											  else
											    '/var/jenkins_service'
											  end
default['citius_jenkins']['master'] 		= '52.229.36.41'
default['citius_jenkins']['master_tag']     = 'master'
default['citius_jenkins']['slave_tag']      = 'slave'
default['citius_jenkins']['slave_name'] 	= node['hostname'] + '-' + node['platform_family']
default['citius_jenkins']['log_file'] 		= node['citius_jenkins']['service_dir'] + '/slave_connection.log'

default['citius_jenkins']['slaves'] = {
  'description' => 'multiple ten description',
  'remote_jenkins_dir' => '/var/jenkins_service',
  'executors' => 3,
  'usage_mode' => 'normal', # 'normal' or 'exclusive'
  'availability' => 'always', # 'always' or 'demand'
  'in_demand_delay' => 1,
  'idle_delay' => 3
}
default['citius_jenkins']['jnlp_slave_port_in_master'] == '9999'
