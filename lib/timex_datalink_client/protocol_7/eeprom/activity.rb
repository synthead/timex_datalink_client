# frozen_string_literal: true

require "timex_datalink_client/helpers/four_byte_formatter"

class TimexDatalinkClient
  class Protocol7
    class Eeprom
      class Activity
        include Helpers::FourByteFormatter

        METADATA_BYTES_BASE = 6
        METADATA_BYTES_SIZE = 5

        attr_accessor :time, :messages, :random_speech

        # Create an Activity instance.
        #
        # @param time [::Time] Time of activity.
        # @param messages [Array<Array<Integer>>] Messages for activity.
        # @param random_speech [Boolean] If activity should have random speech.
        # @return [Activity] Activity instance.
        def initialize(time:, messages:, random_speech:)
          @time = time
          @messages = messages
          @random_speech = random_speech
        end

        # Compile a metadata packet for an activity.
        #
        # @param activity_index [Integer] Activity index.
        # @return [Array<Integer>] Array of integers that represent bytes.
        def metadata_packet(activity_index)
          [
            time.hour,
            time.min,
            messages.count,
            metadata_bytes(activity_index),
            0
          ].flatten
        end

        # Compile a message packet for an activity.
        #
        # @return [Array<Integer>] Array of integers that represent bytes.
        def messages_packet
          four_byte_format_for(messages)
        end

        private

        def metadata_bytes(activity_index)
          METADATA_BYTES_BASE + METADATA_BYTES_SIZE * activity_index
        end
      end
    end
  end
end
