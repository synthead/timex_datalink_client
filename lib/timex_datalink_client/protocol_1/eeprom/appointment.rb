# frozen_string_literal: true

require "timex_datalink_client/helpers/char_encoders"
require "timex_datalink_client/helpers/length_packet_wrapper"

class TimexDatalinkClient
  class Protocol1
    class Eeprom
      class Appointment
        include Helpers::CharEncoders
        prepend Helpers::LengthPacketWrapper

        attr_accessor :time, :message

        # Create an Appointment instance.
        #
        # @param time [::Time] Time of appointment.
        # @param message [String] Appointment text.
        # @return [Appointment] Appointment instance.
        def initialize(time:, message:)
          @time = time
          @message = message
        end

        # Compile a packet for an appointment.
        #
        # @return [Array<Integer>] Array of integers that represent bytes.
        def packet
          [
            time.month,
            time.day,
            time_15m,
            message_characters
          ].flatten
        end

        private

        def time_15m
          time.hour * 4 + time.min / 15
        end

        def message_characters
          eeprom_chars_for(message)
        end
      end
    end
  end
end
