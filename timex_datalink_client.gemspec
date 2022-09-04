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
    "lib/timex_datalink_client/char_encoder.rb",
    "lib/timex_datalink_client/crc.rb",
    "lib/timex_datalink_client/eeprom.rb",
    "lib/timex_datalink_client/eeprom/anniversary.rb",
    "lib/timex_datalink_client/eeprom/appointment.rb",
    "lib/timex_datalink_client/eeprom/list.rb",
    "lib/timex_datalink_client/end.rb",
    "lib/timex_datalink_client/notebook_adapter.rb",
    "lib/timex_datalink_client/start.rb",
    "lib/timex_datalink_client/sync.rb",
    "lib/timex_datalink_client/time.rb",
    "lib/timex_datalink_client/version.rb"
  ]
  s.homepage    = "https://github.com/synthead/timex_datalink_client"
  s.license     = "MIT"

  s.add_dependency "crc", "~> 0.4.2"
  s.add_dependency "rubyserial", "~> 0.6.0"

  s.add_development_dependency "rspec", "~> 3.11.0"
end
