module Totango
  @error_proc = nil
  @timeout = 10

  def self.timeout; return @timeout; end
  def self.timeout=(n); return @timeout=n; end

  def self.on_error(&x); @error_proc = x; end
  def self.error_proc; @error_proc; end

  module Error
    class InvalidEvent < Exception;end
    class NoSID < Exception;end
    class TotangoAPIError < Exception;end
  end

  class Client
    attr :account, :user, :sid
    def initialize(hash={})
      @sid = hash[:sid] || hash["sid"] || nil
      load_sid_from_file if @sid == nil
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
        begin
          Timeout.timeout(Totango.timeout) { @api.get '/pixel.gif/', self.attributes }
        rescue Timeout::Error
          Totango.error_proc.call("Timed out getting data from Totango.") unless Totango.error_proc == nil
        rescue Exception => e
          Totango.error_proc.call("Totango API error #{e.message}") unless Totango.error_proc == nil
        end
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

    private

    def load_sid_from_file
      if File.exist?("./config/totango.yml")
        @sid = YAML.load_file("./config/totango.yml")["sid"]
      end

      return nil
    end

  end
end
