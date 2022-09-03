# frozen_string_literal: true

require "rubyserial"
require "crc"

require "timex_datalink_client/char_encoder"
require "timex_datalink_client/crc"
require "timex_datalink_client/end"
require "timex_datalink_client/notebook_adapter"
require "timex_datalink_client/start"
require "timex_datalink_client/sync"
require "timex_datalink_client/time"
require "timex_datalink_client/version"

class TimexDatalinkClient
  attr_accessor :serial_device, :models

  def initialize(serial_device:, models: [])
    @serial_device = serial_device
    @models = models
  end

  def write
    packets = models.map(&:packets).flatten
    notebook_adapter.write(packets)
  end

  private

  def notebook_adapter
    @notebook_adapter ||= NotebookAdapter.new(serial_device)
  end
end
