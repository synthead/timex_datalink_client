# frozen_string_literal: true

class TimexDatalinkClient
  class NotebookAdapter
    attr_accessor :serial_device, :serial_sleep

    def initialize(serial_device:, serial_sleep: 0.025)
      @serial_device = serial_device
      @serial_sleep = serial_sleep
    end

    def write(bytes)
      bytes.each_char do |byte|
        serial.write(byte)
        sleep(serial_sleep)
      end
    end

    private

    def serial
      @serial ||= Serial.new(serial_device)
    end
  end
end
