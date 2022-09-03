# frozen_string_literal: true

class TimexDatalinkClient
  class NotebookAdapter
    BYTE_SLEEP = 0.025
    PACKET_SLEEP = 0.25

    attr_accessor :serial_device

    def initialize(serial_device)
      @serial_device = serial_device
    end

    def write(packets)
      packets.each do |packet|
        packet.each_byte do |byte|
          serial.write(byte.chr)

          sleep(BYTE_SLEEP)
        end

        sleep(PACKET_SLEEP)
      end
    end

    private

    def serial
      @serial ||= Serial.new(serial_device)
    end
  end
end
