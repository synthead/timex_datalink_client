# frozen_string_literal: true

class TimexDatalinkClient
  module Serial
    def serial
      @serial ||= Serial.new(
        serial_device: serial_device,
        post_write_sleep: post_write_sleep
      )
    end

    class Serial
      POST_WRITE_SLEEP_DEFAULT = 0.025

      attr_reader :serial_device, :post_write_sleep

      def initialize(serial_device:, post_write_sleep: nil)
        @serial_device = serial_device
        @post_write_sleep = post_write_sleep || POST_WRITE_SLEEP_DEFAULT
      end

      def write(serial_data)
        serial.write(serial_data)
        sleep(post_write_sleep)
      end

      private

      def serial
        @serial ||= ::Serial.new(serial_device)
      end
    end
  end
end
