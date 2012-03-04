require File.join(File.dirname(__FILE__), 'options_helper.rb')

module DevCloud
  module Options
    class Creation
      def self.to_hash(chef_resource, ctid, hostid='101', subnet='10.10')
        ctid = ctid.to_i; hostid = hostid.to_i
    
        {
          :ipadd => "#{subnet}.#{hostid}.#{ctid}",
          :hostname => sprintf("vm%.3d-%.3d.development.my_company.com", hostid, ctid),
          :ostemplate => chef_resource.ostemplate
        }
      end
    end

    class Initialization
      include OptionsHelper
      
      attr_reader :chef_resource

      def self.to_hash(chef_resource)
        self.new(chef_resource).to_hash
      end
      
      def initialize(chef_resource)
        @chef_resource = chef_resource
        expand_instance_type_params!
      end
      
      def to_hash
        memory_options.
          merge(unprocessed_options).
          merge(misc_options)
      end

      def memory_options
        memory = (chef_resource.memory * 1024 / 4).to_i # Since 1 page = 4 KiB
        barrier = (memory * 3 / 4).to_i       # Barrier is 3/4th of raw memory
        swap = (chef_resource.swap * 1024 / 4).to_i
        ram = (memory + swap).to_i
        kmemsize = [(chef_resource.memory * 1024 * 1024 * 0.1), (400 * 1024 * 1024)].max.to_i

        {
          :physpages => "#{barrier}:#{ram}",
          :vmguarpages => "#{barrier}:#{ram}",
          :oomguarpages => "#{ram}:#{(ram * 1.3).to_i}",
          :kmemsize => kmemsize,
          :swappages => "0:#{swap}",
        }
      end

      def misc_options
        description = Description.generate(chef_resource).to_json
        { :description => "'#{description}'",
          :numproc => "100:500",
          :diskinodes => "#{chef_resource.diskinodes}:#{chef_resource.diskinodes}",
          :diskspace => "#{to_diskspace_blocks(chef_resource)}:#{to_diskspace_blocks(chef_resource)}"
        }
      end

      def to_diskspace_blocks(resource)
        resource.diskspace.to_i * 1024 * 1024 # Blocks are in KiB
      end

      def unprocessed_options
        {
          :cpulimit => chef_resource.cpulimit.to_i,
          :cpus => chef_resource.cpus.to_i,
          :searchdomain => "'#{chef_resource.searchdomain.gsub(/'/,'')}'",
          :nameserver => "'#{chef_resource.nameserver.gsub(/'/,'')}'",
          :userpasswd => "'#{chef_resource.userpasswd}'"
        }
      end
    end
  end
end
