require 'openvz'

module DevCloud
  class Container

    attr_reader :vm

    def initialize(vm)
      @vm = vm
    end

    class << self
      def find_or_create(chef_resource)
        container = find_by_name(chef_resource.name) || create(chef_resource)
        container.update(chef_resource)
      end

      def find(name)
        raise "Container #{name} does not exist" unless container = find_by_name(name, :mute_logging)
        container
      end

      def find_by_name(name, logging=:on)
        inventory = OpenVZ::Inventory.new.tap{|i| i.load}
        vm = inventory.to_hash.collect do |k, v|
          v if v.config.description.is_a?(String) and Options::Description.parse(v.config.description).to_hash['name'] == name
        end.compact.first

        if vm
          Chef::Log.info("OpenVZ Container '#{name}' with hostname '#{vm.config.hostname}' exists") if logging == :on
          self.new(vm)
        else
          nil
        end
      end

      def create(chef_resource)
        ctid = CTids.register(chef_resource.name)
        initial_options = Options::Creation.to_hash(chef_resource, ctid)
        Chef::Log.debug("incoming Chef Resource -- #{chef_resource.inspect}")
        Chef::Log.info("creating OpenVZ container CTID:#{ctid} HOSTNAME:#{initial_options[:hostname]} and OSTEMPLATE:#{initial_options[:ostemplate]}")

        vm = OpenVZ::Container.new(ctid)
        vm.create(initial_options)
        
        Chef::Log.info("OpenVZ Container #{initial_options[:hostname]} with #{initial_options[:ostemplate]} now exists")

        self.new(vm).tap do |container|
          container.update(chef_resource)
        end
      end
    end

    def update(chef_resource)
      changed_params = compare_vmconfig_and(chef_resource)

      vm.set(changed_params) if changed_params.any?
      log_update(changed_params)
    end

    def start
      unless running?
        Chef::Log.info("starting container: #{vm.config.hostname}")
        vm.start
      end
      Chef::Log.info("Mounted and running: #{vm.config.hostname}")
    end

    def running?
      vm.status.include?("running")
    end

    private
    def compare_vmconfig_and(chef_resource)
      hash = Options::Initialization.to_hash(chef_resource)
      hash.delete(:description) if Options::Description.parse(vm.config.description) == Options::Description.generate(chef_resource)
      hash.delete(:searchdomain) if hash[:searchdomain].gsub(/'/,'') == vm.config.searchdomain
      hash.delete(:nameserver) if hash[:nameserver].gsub(/'/,'') == vm.config.nameserver
      hash.delete(:userpasswd) if is_root_password?(hash[:userpasswd].split(/:/).last.chomp("'"))
      hash.reject! { |k, v| vm.config[k].to_s == v.to_s }
      
      hash
    end

    def is_root_password?(plain_passwd)
      return true unless running? # Don't change the password if the CT has been halted
      vm.command("cat /etc/shadow") =~ /^root:(.*?):.*/; stored_passwd = $1
      return false if stored_passwd.length < 3
      stored_passwd =~ /(.*\$)/; salt = $1
      Chef::Log.debug("Stored Passwd; Generated Passwd -- #{stored_passwd}; #{plain_passwd.crypt(salt)}")
      stored_passwd == plain_passwd.crypt(salt)
    end

    def log_update(changed_params)
      Chef::Log.info("No options changed for OpenVZ Container '#{vm.config.hostname}'") and return if changed_params.empty?
      Chef::Log.info("changing options for container: #{vm.config.hostname} =>")
      Chef::Log.info(changed_params.collect do |k, v|
                       if k == :userpasswd
                         sprintf("\n%20s", "updating password for root") 
                       else
                         sprintf("\n%20s\n%25s => %s\n%25s => %s", k, 'was', vm.config[k], 'setting to', v)
                       end
                     end.join)
    end
   end
end
