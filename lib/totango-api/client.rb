module Totango

  module Error
    class InvalidEvent < Exception;end
    class NoSID < Exception;end
  end

  class Client
    attr :account, :user
    def initialize(hash={})
      @sid = hash[:sid] || hash["sid"] || nil
      raise Totango::Error::NoSID, "No SID provided" unless @sid
      @user_attributes = hash[:user] || hash["user"] || {}
      @account_attributes = hash[:account] || hash["account"] || {}
      @attributes = {}
      @attributes["sdr_s"] = @sid
      @attributes["sdr_a"] = hash[:action] || hash["action"]
      @attributes["sdr_m"] = hash[:module] || hash["module"]
      @account = Totango::Account.new(@account_attributes)
      @user = Totango::User.new(@user_attributes)

      @api = Faraday.new(url: "https://sdr.totango.com/")  do |faraday|
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def attributes
      @attributes.merge(@user.attributes).merge(@account.attributes)
    end

    def save 
     if valid? then
        @api.get '/pixel.gif/', self.attributes
     else
       raise Totango::Error::InvalidEvent
     end
    end

    def valid?
      return false if @account.id == nil
      return false if @user.attributes.keys.grep(/sdr_u\./).count > 0 and @user.attributes["sdr_u"] == nil
      return true
    end

    def self.create(args)
      event = Client.new(args)
      event.save
      return event
    end


  end
end
