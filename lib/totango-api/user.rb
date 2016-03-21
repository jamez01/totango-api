module Totango
  class User
    def initialize(args = {})
      @attributes = Hash.new(nil)
      args.each {|k,v| self.send("#{k}=".to_sym,v)}
    end

    def id
      @attributes["sdr_u"]
    end
    def id=(id)
      @attributes["sdr_u"]=id
    end

    def name
      @attributes["sdr_u.name"]
    end
    def name=(n)
      @attributes["sdr_u.name"]=n
    end

    def method_missing(s,*args)
      m=s.to_s.sub(/=$/,"")
      attr_name = "sdr_u.#{m}"
      return @attributes[attr_name] = "#{args.join(" ")}" if args.length > 0
      raise NoMethodError, "#{s.to_s} for #{self.class}" unless @attributes[attr_name]
      return @attributes[attr_name]
    end

    def attributes
      @attributes.delete_if {|k,v| v.nil? }
    end

  end
end
