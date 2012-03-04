require 'ostruct'

module DevCloud
  module Options
    module OptionsHelper
      def expand_instance_type_params!
        if chef_resource.instance_type
          defaults = InstanceType.send(chef_resource.instance_type)
          @chef_resource = OpenStruct.new(defaults.merge(overrides))
        end
      end

      def overrides
        params = [:name, :billing, :description, :memory, :cpus, :cpulimit, :diskspace, :swap, :diskinodes, :nameserver, :searchdomain, :userpasswd, :instance_type]
        Hash[chef_resource.to_hash.select{ |k, v| params.include?(k) and v }] # TODO: this is not compatible with Ruby 1.9
      end
    end
  end
end
