# frozen_string_literal: true

require "rubyserial"

require "timex_datalink_client/serial"
require "timex_datalink_client/sync"
require "timex_datalink_client/version"

class TimexDatalinkClient
  include Serial
  include Sync

  attr_reader :serial_device, :post_write_sleep

  def initialize(serial_device:, post_write_sleep: nil)
    @serial_device = serial_device
    @post_write_sleep = post_write_sleep
  end
end
