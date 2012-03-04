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
