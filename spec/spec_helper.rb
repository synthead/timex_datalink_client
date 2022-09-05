# frozen_string_literal: true

require "helpers/crc_helpers"

RSpec.configure do |rspec|
  rspec.include CrcHelpers, :crc
end
