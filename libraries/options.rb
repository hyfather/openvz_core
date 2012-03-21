require File.join(File.dirname(__FILE__), 'options_helper.rb')

# This file is part of the 'OpenVZ Core LWRP'
#  
#   'OpenVZ Core LWRP' is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
#  
#     'OpenVZ Core LWRP' is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#  
#     You should have received a copy of the GNU General Public License
#     along with 'OpenVZ Core LWRP'.  If not, see <http://www.gnu.org/licenses/>.
#  
#     For the source code, see -- https://github.com/hyfather/openvz_core
#     Contact me at -- mail@hyfather.com

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
