# frozen_string_literal: true

require "timex_datalink_client/helpers/char_encoders"

class TimexDatalinkClient
  class Protocol9
    class Eeprom
      class Chrono
        include Helpers::CharEncoders

        CHRONO_LABEL_LENGTH = 8
        CHRONO_INITIAL_SIZE = 14

        attr_accessor :label, :laps

        # Create a Chrono instance.
        #
        # @param label [String] Label for chrono.
        # @param laps [Integer] Number of laps for chrono.
        # @return [Chrono] Chrono instance.
        def initialize(label:, laps:)
          @label = label
          @laps = laps
        end

        # Compile a packet for a chrono.
        #
        # @return [Array<Integer>] Array of integers that represent bytes.
        def packet
          label_characters
        end

        def chrono_bytesize
          CHRONO_INITIAL_SIZE + laps * 4
        end

        private

        def label_characters
          centered_label = label.center(CHRONO_LABEL_LENGTH)

          chars_for(centered_label, length: CHRONO_LABEL_LENGTH)
        end
      end
    end
  end
end
