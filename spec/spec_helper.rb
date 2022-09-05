# frozen_string_literal: true

require "timex_datalink_client"

require "helpers/crc_helpers"
require "helpers/length_packet_helpers"

RSpec.configure do |rspec|
  rspec.include CrcHelpers, :crc
  rspec.include LengthPacketHelpers, :length_packet
end
