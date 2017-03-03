# configures .netrc file in home directory
netrc_user = data_bag_item('pipeline', 'git')
template "#{ENV['HOME']}/.netrc" do
  source 'netrc.erb'
  owner 'root'
  group 'root'
  mode 00644
  variables(
    :user => netrc_user['username'],
    :token => netrc_user['password']
  )
end
