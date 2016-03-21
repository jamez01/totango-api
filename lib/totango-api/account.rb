module Totango
  class Account

    def initialize(args = {})
      @attributes = Hash.new(nil)
      args.each {|k,v| self.send("#{k}=".to_sym,v)}
    end

    def id
      @attributes["sdr_o"]
    end
    def id=(id)
      @attributes["sdr_o"] = id
    end

    def ofid
      @attributes["sdr_ofid"]
    end
    def ofid=(ofid)
      @attributes["sdr_ofid"]=ofid
    end

    def account_name
      @attributes["sdr_odn"]
    end
    def account_name=(name)
      @attributes["sdr_odn"]=name
    end

    def create_date
      @attributes["sdr_o_Create Date"]
    end
    def create_date=(date)
      @attributes["sdr_o_Create Date"] = to_xmlschema(date)
    end

    def contract_renewal
      @attributes["sdr_o_Contract Renewal Date"]
    end
    def contract_renewal=(date)
      @attributes["sdr_o_Contract Renewal Date"] = to_xmlschema(date)
    end

    def contract_value
      @attributes["sdr_o_Contract Value"]
    end
    def contract_value=(n)
      @attributes["sdr_o_Contract value"] = n.to_i
    end

    def licenses
      @attributes["sdr_o_Licenses"]
    end
    def licenses=(n)
      @attributes["sdr_o_Licenses"] = n.to_i
    end

    def sales_manager
      @attributes["sdr_o_Sales Manager"]
    end
    def sales_manager=(s)
      @attributes["sdr_o_Sales Manager"]=s
    end

    def success_manager
      @attributes["sdr_o_Success Manager"]
    end
    def success_manager=(s)
      @attributes["sdr_o_Sucsess Manager"]=s
    end

    def status
      @attributes["sdr_o_Status"]
    end
    def status=(s)
      @attributes["sdr_o_Status"]=s
    end

    def attributes
      @attributes.delete_if {|k,v| v.nil? }
    end

    def method_missing(s,*args)
      m=s.to_s.sub(/=$/,"")
      attr_name = "sdr_o.#{m}"
      return @attributes[attr_name] = "#{args.join(" ")}" if args.length > 0
      raise NoMethodError, "#{s.to_s} for #{self.class}" unless @attributes[attr_name]
      return @attributes[attr_name]
    end

    private

    def to_xmlschema(date)
      xml_date = case date.class.to_s
      when String
        DateTime.parse(date)
      when DateTime
        date
      when Time
        date.to_datetime
      when Date
        date.to_datetime
      end

      return xml_date.xmlschema
    end
  end
end
