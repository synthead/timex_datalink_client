# frozen_string_literal: true

require "rubyserial"

require "timex_datalink_client/notebook_adapter"
require "timex_datalink_client/sync"
require "timex_datalink_client/version"

class TimexDatalinkClient
  attr_accessor :serial_device, :models_to_write

  def initialize(serial_device)
    @serial_device = serial_device
    @models_to_write = []
  end

  def write
    models_to_write.each do |model|
      notebook_adapter.write(model.render)
    end
  end

  private

  def notebook_adapter
    @notebook_adapter ||= NotebookAdapter.new(serial_device: serial_device)
  end
end
