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
    class Description
      attr_accessor :mash

      def initialize(mash)
        @mash = mash
      end
      
      def self.parse(json)
        self.new Mash.from_hash(json ? JSON.parse(json) : {})
      end
      
      def self.generate(chef_resource)
        raw = [:name, :description, :billing, :instance_type].map do |attr|
          [attr, chef_resource.send(attr).gsub(/(")|(')|(#)|(,)/, '').gsub(/\s+/, ' ')]
        end
        raw << [:created, Time.now.to_s]
        
        self.new Mash[raw]
      end
      
      def to_json
        mash.to_json
      end

      def to_hash
        mash.to_hash
      end

      def ==(other_description)
        Mash.new(self.to_hash).tap {|x| x.delete(:created) } == Mash.new(other_description.to_hash).tap {|x| x.delete(:created) }
      end
    end
  end
end
