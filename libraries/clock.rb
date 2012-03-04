module DevCloud
  class Clock
    class << self
      @@now = nil
      def now
        @@now || Time.now
      end

      def reset
        @@now = nil
      end

      def set(now)
        @@now = now
      end

    end
  end  
end
