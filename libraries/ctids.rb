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
