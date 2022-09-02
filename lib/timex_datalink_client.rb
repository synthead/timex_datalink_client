# frozen_string_literal: true

require "rubyserial"

require "timex_datalink_client/sync"
require "timex_datalink_client/version"

class TimexDatalinkClient
  attr_accessor :serial_device, :serial_sleep, :models_to_write

  def initialize(serial_device:, serial_sleep: 0.025)
    @serial_device = serial_device
    @serial_sleep = serial_sleep
    @models_to_write = []
  end

  def write
    models_to_write.each do |model|
      write_serial(model.render)
    end
  end

  private

  def serial
    @serial ||= Serial.new(serial_device)
  end

  def write_serial(bytes)
    bytes.each_char do |byte|
      serial.write(byte)
      sleep(serial_sleep)
    end
  end
end
