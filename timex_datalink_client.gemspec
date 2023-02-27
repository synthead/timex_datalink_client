# frozen_string_literal: true

require_relative "lib/timex_datalink_client/version.rb"

Gem::Specification.new do |s|
  s.name        = "timex_datalink_client"
  s.version     = TimexDatalinkClient::VERSION
  s.summary     = "Write data to Timex Datalink devices with an optical sensor"
  s.authors     = ["Maxwell Pray"]
  s.email       = "synthead@gmail.com"
  s.homepage    = "https://github.com/synthead/timex_datalink_client/tree/v#{s.version}"
  s.license     = "MIT"

  s.files       = [
    "lib/timex_datalink_client.rb",
    "lib/timex_datalink_client/notebook_adapter.rb",
    "lib/timex_datalink_client/version.rb",

    "lib/timex_datalink_client/helpers/char_encoders.rb",
    "lib/timex_datalink_client/helpers/cpacket_paginator.rb",
    "lib/timex_datalink_client/helpers/crc_packets_wrapper.rb",
    "lib/timex_datalink_client/helpers/four_byte_formatter.rb",
    "lib/timex_datalink_client/helpers/length_packet_wrapper.rb",
    "lib/timex_datalink_client/helpers/lsb_msb_formatter.rb",

    "lib/timex_datalink_client/protocol_1/alarm.rb",
    "lib/timex_datalink_client/protocol_1/eeprom.rb",
    "lib/timex_datalink_client/protocol_1/eeprom/anniversary.rb",
    "lib/timex_datalink_client/protocol_1/eeprom/appointment.rb",
    "lib/timex_datalink_client/protocol_1/eeprom/list.rb",
    "lib/timex_datalink_client/protocol_1/eeprom/phone_number.rb",
    "lib/timex_datalink_client/protocol_1/end.rb",
    "lib/timex_datalink_client/protocol_1/start.rb",
    "lib/timex_datalink_client/protocol_1/sync.rb",
    "lib/timex_datalink_client/protocol_1/time.rb",
    "lib/timex_datalink_client/protocol_1/time_name.rb",

    "lib/timex_datalink_client/protocol_3/alarm.rb",
    "lib/timex_datalink_client/protocol_3/eeprom.rb",
    "lib/timex_datalink_client/protocol_3/eeprom/anniversary.rb",
    "lib/timex_datalink_client/protocol_3/eeprom/appointment.rb",
    "lib/timex_datalink_client/protocol_3/eeprom/list.rb",
    "lib/timex_datalink_client/protocol_3/eeprom/phone_number.rb",
    "lib/timex_datalink_client/protocol_3/end.rb",
    "lib/timex_datalink_client/protocol_3/sound_options.rb",
    "lib/timex_datalink_client/protocol_3/sound_theme.rb",
    "lib/timex_datalink_client/protocol_3/start.rb",
    "lib/timex_datalink_client/protocol_3/sync.rb",
    "lib/timex_datalink_client/protocol_3/time.rb",
    "lib/timex_datalink_client/protocol_3/wrist_app.rb",

    "lib/timex_datalink_client/protocol_4/alarm.rb",
    "lib/timex_datalink_client/protocol_4/eeprom.rb",
    "lib/timex_datalink_client/protocol_4/eeprom/anniversary.rb",
    "lib/timex_datalink_client/protocol_4/eeprom/appointment.rb",
    "lib/timex_datalink_client/protocol_4/eeprom/list.rb",
    "lib/timex_datalink_client/protocol_4/eeprom/phone_number.rb",
    "lib/timex_datalink_client/protocol_4/end.rb",
    "lib/timex_datalink_client/protocol_4/sound_options.rb",
    "lib/timex_datalink_client/protocol_4/sound_theme.rb",
    "lib/timex_datalink_client/protocol_4/start.rb",
    "lib/timex_datalink_client/protocol_4/sync.rb",
    "lib/timex_datalink_client/protocol_4/time.rb",
    "lib/timex_datalink_client/protocol_4/wrist_app.rb",

    "lib/timex_datalink_client/protocol_6/end.rb",
    "lib/timex_datalink_client/protocol_6/night_mode_options.rb",
    "lib/timex_datalink_client/protocol_6/pager_options.rb",
    "lib/timex_datalink_client/protocol_6/start.rb",
    "lib/timex_datalink_client/protocol_6/sync.rb",
    "lib/timex_datalink_client/protocol_6/time.rb",

    "lib/timex_datalink_client/protocol_7/eeprom.rb",
    "lib/timex_datalink_client/protocol_7/eeprom/activity.rb",
    "lib/timex_datalink_client/protocol_7/eeprom/calendar.rb",
    "lib/timex_datalink_client/protocol_7/eeprom/calendar/event.rb",
    "lib/timex_datalink_client/protocol_7/eeprom/games.rb",
    "lib/timex_datalink_client/protocol_7/eeprom/phone_number.rb",
    "lib/timex_datalink_client/protocol_7/eeprom/speech.rb",
    "lib/timex_datalink_client/protocol_7/end.rb",
    "lib/timex_datalink_client/protocol_7/phrase_builder.rb",
    "lib/timex_datalink_client/protocol_7/start.rb",
    "lib/timex_datalink_client/protocol_7/sync.rb",

    "lib/timex_datalink_client/protocol_9/alarm.rb",
    "lib/timex_datalink_client/protocol_9/eeprom.rb",
    "lib/timex_datalink_client/protocol_9/eeprom/chrono.rb",
    "lib/timex_datalink_client/protocol_9/eeprom/phone_number.rb",
    "lib/timex_datalink_client/protocol_9/end.rb",
    "lib/timex_datalink_client/protocol_9/sound_options.rb",
    "lib/timex_datalink_client/protocol_9/start.rb",
    "lib/timex_datalink_client/protocol_9/sync.rb",
    "lib/timex_datalink_client/protocol_9/time.rb",
    "lib/timex_datalink_client/protocol_9/time_name.rb",
    "lib/timex_datalink_client/protocol_9/timer.rb"
  ]

  s.add_dependency "activemodel", "~> 7.0.4"
  s.add_dependency "crc", "~> 0.4.2"
  s.add_dependency "mdb", "~> 0.5.0"
  s.add_dependency "rubyserial", "~> 0.6.0"

  s.add_development_dependency "mdl", "~> 0.12.0"
  s.add_development_dependency "rspec", "~> 3.11.0"
  s.add_development_dependency "rubocop", "~> 1.41.1"
  s.add_development_dependency "rubocop-github", "~> 0.20.0"
  s.add_development_dependency "tzinfo", "~> 2.0.5"
  s.add_development_dependency "yard-junk", "~> 0.0.9"
end
