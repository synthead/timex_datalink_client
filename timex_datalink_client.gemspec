# frozen_string_literal: true

require_relative "lib/timex_datalink_client/version.rb"

Gem::Specification.new do |s|
  s.name        = "timex_datalink_client"
  s.version     = TimexDatalinkClient::VERSION
  s.summary     = "Client for optical Timex Datalink watches"
  s.description = "Write data to Timex Datalink watches with an optical sensor"
  s.authors     = ["Maxwell Pray"]
  s.email       = "synthead@gmail.com"
  s.files       = [
    "lib/timex_datalink_client.rb",
    "lib/timex_datalink_client/version.rb"
  ]
  s.homepage    = "https://github.com/synthead/timex_datalink_client"
  s.license     = "MIT"

  s.add_dependency "rubyserial", "~> 0.6.0"

  s.add_development_dependency "rspec", "~> 3.11.0"
end
