action :create do
  DevCloud::Container.find_or_create(new_resource)
end

action :start do
  container = DevCloud::Container.find(new_resource.name)
  container.start
end

action :nothing do
  Chef::Log.info("Taking no action for container:#{new_resource.name}")
end
