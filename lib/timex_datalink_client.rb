# frozen_string_literal: true

require "rubyserial"
require "crc"

require "timex_datalink_client/crc"
require "timex_datalink_client/end"
require "timex_datalink_client/notebook_adapter"
require "timex_datalink_client/start"
require "timex_datalink_client/sync"
require "timex_datalink_client/version"

class TimexDatalinkClient
  attr_accessor :serial_device, :models_to_write

  def initialize(serial_device)
    @serial_device = serial_device
    @models_to_write = []
  end

  def write
    rendered_models = models_to_write.map(&:render)
    notebook_adapter.write(rendered_models)
  end

  private

  def notebook_adapter
    @notebook_adapter ||= NotebookAdapter.new(serial_device)
  end
end
