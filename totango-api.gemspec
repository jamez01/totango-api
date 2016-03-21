Gem::Specification.new do |g|
  g.name = "totango-api"
  g.version = "0.0.1"
  g.date = "2016-02-19"
  g.summary = "Totango-API"
  g.description = "A ruby wrapper for the totango API"
  g.authors = ["James Paterni"]
  g.email = "james@ruby-code.com"
  g.add_runtime_dependency "faraday", '~> 0'
  g.license = "GPL-2.0"
  g.files = %w{lib/totango-api.rb lib/totango-api/client.rb lib/totango-api/account.rb lib/totango-api/user.rb}
end
