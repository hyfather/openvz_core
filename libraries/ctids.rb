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
  class CTids
    def self.register(name="No desc given")
      all_ctids = Chef::DataBagItem.load('openvz_ctids', 'list')
      Chef::Log.debug("All existing CTIDS -- \n #{all_ctids.inspect}")

      hsh = all_ctids.to_hash
      next_ctid = hsh.sort.find{|pair| pair.last.empty?}.first
      Chef::Log.info("Next CTID found => #{next_ctid}")
      all_ctids[next_ctid] = "#{name} -- #{Time.now}"
      all_ctids.save

      next_ctid
    end

    def self.unregister(ctid)
      all_ctids = Chef::DataBagItem.load('openvz_ctids', 'list')
      Chef::Log.info("about to delete CTID: #{ctid}")
      all_ctids[ctid] = ""
      all_ctids.save
      Chef::Log.info("deleted CTID: #{ctid}")
    end
  end
end
