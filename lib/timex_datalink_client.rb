# frozen_string_literal: true

require "timex_datalink_client/alarm"
require "timex_datalink_client/eeprom"
require "timex_datalink_client/eeprom/anniversary"
require "timex_datalink_client/eeprom/appointment"
require "timex_datalink_client/eeprom/list"
require "timex_datalink_client/eeprom/phone_number"
require "timex_datalink_client/end"
require "timex_datalink_client/notebook_adapter"
require "timex_datalink_client/sound_options"
require "timex_datalink_client/sound_theme"
require "timex_datalink_client/start"
require "timex_datalink_client/sync"
require "timex_datalink_client/time"
require "timex_datalink_client/version"
require "timex_datalink_client/wrist_app"

class TimexDatalinkClient
  attr_accessor :serial_device, :models

  def initialize(serial_device:, models: [])
    @serial_device = serial_device
    @models = models
  end

  def write
    notebook_adapter.write(packets)
  end

  private

  def packets
    models.map(&:packets).flatten(1)
  end

  def notebook_adapter
    @notebook_adapter ||= NotebookAdapter.new(serial_device)
  end
end
