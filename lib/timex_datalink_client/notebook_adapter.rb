# frozen_string_literal: true

require "rubyserial"

class TimexDatalinkClient
  class NotebookAdapter
    BYTE_SLEEP_DEFAULT = 0.025
    PACKET_SLEEP_DEFAULT = 0.25

    attr_accessor :serial_device, :byte_sleep, :packet_sleep, :verbose

    def initialize(serial_device:, byte_sleep: nil, packet_sleep: nil, verbose: false)
      @serial_device = serial_device
      @byte_sleep = byte_sleep || BYTE_SLEEP_DEFAULT
      @packet_sleep = packet_sleep || PACKET_SLEEP_DEFAULT
      @verbose = verbose
    end

    def write(packets)
      packets.each do |packet|
        packet.each do |byte|
          printf("%.2X ", byte) if verbose

          serial.write(byte.chr)

          sleep(byte_sleep)
        end

        sleep(packet_sleep)

        puts if verbose
      end
    end

    private

    def serial
      @serial ||= Serial.new(serial_device)
    end
  end
end
