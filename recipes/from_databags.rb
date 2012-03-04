all_containers = data_bag('openvz_containers')
Chef::Log.info("Found a total of #{all_containers.size} containers in data_bag[openvz_containers]")
Chef::Log.debug("Sorted data_bag[openvz_containers]: #{all_containers.sort.inspect}")

all_containers.sort.each do |ct_name|
  details = data_bag_item('openvz_containers', ct_name)
  Chef::Log.debug("Details from data_bag '#{ct_name}' -- #{details.inspect}")

  openvz_core_container ct_name do
    action        parse_actions(details['action'])

    ctid          details['ctid']
    description   details['description']
    billing       details['billing']
    ostemplate    details['ostemplate']

    instance_type details['instance_type']
    
    cpulimit      details['cpulimit']
    cpus          details['cpus']
    memory        details['memory']
    diskspace     details['diskspace']
    swap          details['swap']
    diskinodes    details['diskinodes']

    nameserver    details['nameserver']
    searchdomain  details['searchdomain']
    userpasswd    details['userpasswd']
  end
end

def parse_actions(actions)
  return [:create, :start] unless actions
  actions.gsub(/,/, '').split(/\s/).map(&:to_sym)
end
