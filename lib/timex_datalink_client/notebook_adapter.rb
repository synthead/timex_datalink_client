# frozen_string_literal: true

require "rubyserial"

class TimexDatalinkClient
  class NotebookAdapter
    BYTE_SLEEP = 0.025
    PACKET_SLEEP = 0.25

    attr_accessor :serial_device, :verbose

    def initialize(serial_device:, verbose: false)
      @serial_device = serial_device
      @verbose = verbose
    end

    def write(packets)
      packets.each do |packet|
        packet.each do |byte|
          printf("%.2X ", byte) if verbose

          serial.write(byte.chr)

          sleep(BYTE_SLEEP)
        end

        sleep(PACKET_SLEEP)

        puts if verbose
      end
    end

    private

    def serial
      @serial ||= Serial.new(serial_device)
    end
  end
end
