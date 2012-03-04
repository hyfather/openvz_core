require 'ostruct'

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
#     along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
#  
#     For the source code, see -- https://github.com/hyfather/openvz_core
#     Contact me at -- mail@hyfather.com

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
