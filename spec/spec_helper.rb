# frozen_string_literal: true

require "timex_datalink_client"

require "helpers/crc_helpers"

RSpec.configure do |rspec|
  rspec.include CrcHelpers, :crc
end
