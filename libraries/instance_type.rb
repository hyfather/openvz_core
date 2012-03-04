require 'ostruct'
module DevCloud
  class InstanceType
    class << self
      def common
        # TODO -- externalize this configuration
        {
          :nameserver => '10.10.100.0',
          :searchdomain => "development.my_company.com"
          :userpasswd => "root:password"
        }
      end
      
      def micro
        common.merge({
          :memory => 1024,
          :cpus => 1,
          :cpulimit => 25,
          :diskspace => 8,
          :swap => 512,
          :diskinodes => 200000
        })
      end

      def small
        common.merge({
          :memory => 2048,
          :cpus => 1,
          :cpulimit => 50,
          :diskspace => 10,
          :swap => 512,
          :diskinodes => 200000
        })
      end

      def small_high_disk
        common.merge({
          :memory => 2048,
          :cpus => 1,
          :cpulimit => 25,
          :diskspace => 50,
          :swap => 512,
          :diskinodes => 200000
        })
      end

      def medium
        common.merge({
          :memory => 4096,
          :cpus => 1,
          :cpulimit => 50,
          :diskspace => 10,
          :swap => 1024,
          :diskinodes => 400000
        })
      end

      def medium_high_cpu
        common.merge({
          :memory => 4096,
          :cpus => 1,
          :cpulimit => 100,
          :diskspace => 10,
          :swap => 1024,
          :diskinodes => 400000
        })
      end

      def large
        common.merge({
          :memory => 8192,
          :cpus => 1,
          :cpulimit => 100,
          :diskspace => 20,
          :swap => 2048,
          :diskinodes => 400000
        })
      end

      def large_high_cpu
        common.merge({
          :memory => 8192,
          :cpus => 2,
          :cpulimit => 100,
          :diskspace => 20,
          :swap => 2048,
          :diskinodes => 400000
        })
      end

      def large_high_disk
        common.merge({
          :memory => 8192,
          :cpus => 1,
          :cpulimit => 50,
          :diskspace => 100,
          :swap => 2048,
          :diskinodes => 400000
        })
      end
    end
  end
end
