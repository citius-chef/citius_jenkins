
include_recipe 'iptables::default'

iptables_rule 'http80' do
  action :enable
end
iptables_rule 'http8080' do
  action :enable
end
iptables_rule 'http22' do
  action :enable
end
iptables_rule 'redirect8080' do
  action :enable
end
