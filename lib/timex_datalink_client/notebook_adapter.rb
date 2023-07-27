# frozen_string_literal: true

require "serialport"

class TimexDatalinkClient
  class NotebookAdapter
    BYTE_SLEEP_DEFAULT = 0.025
    PACKET_SLEEP_DEFAULT = 0.25

    attr_accessor :serial_device, :byte_sleep, :packet_sleep, :verbose

    # Create a NotebookAdapter instance.
    #
    # @param serial_device [String] Path to serial device.
    # @param byte_sleep [Integer, nil] Time to sleep after sending byte.
    # @param packet_sleep [Integer, nil] Time to sleep after sending packet of bytes.
    # @param verbose [Boolean] Write verbose output to console.
    # @return [NotebookAdapter] NotebookAdapter instance.
    def initialize(serial_device:, byte_sleep: nil, packet_sleep: nil, verbose: false)
      @serial_device = serial_device
      @byte_sleep = byte_sleep || BYTE_SLEEP_DEFAULT
      @packet_sleep = packet_sleep || PACKET_SLEEP_DEFAULT
      @verbose = verbose
    end

    # Write packets of bytes to serial device.
    #
    # @param packets [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
    # @return [void]
    def write(packets)
      packets.each do |packet|
        packet.each do |byte|
          printf("%.2X ", byte) if verbose

          serial_port.write(byte.chr)

          sleep(byte_sleep)
        end

        sleep(packet_sleep)

        puts if verbose
      end
    end

    private

    def serial_port
      @serial_port ||= SerialPort.new(serial_device)
    end
  end
end
