# frozen_string_literal: true

class TimexDatalinkClient
  class Protocol7
    class Eeprom
      class Activity
        METADATA_BYTES_BASE = 6
        METADATA_BYTES_SIZE = 5

        MESSAGES_HEADERS = [0xc0, 0x30, 0x0c, 0x03, 0x00]
        MESSAGES_NULL = 0x00
        MESSAGES_TERMINATOR_MIDDLE = 0xfe
        MESSAGES_TERMINATOR_END = 0xff

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
          [].tap do |message_bytes|
            messages.each_with_index do |message_line, message_line_index|
              message_line_remaining = message_line.dup

              loop do
                message_packet = message_line_remaining.shift(4)
                message_bytes << MESSAGES_HEADERS[message_packet.count]

                message_bytes.concat(message_packet)

                next if message_packet.count == 4

                has_next_line = messages[message_line_index + 1]
                terminator = has_next_line ? MESSAGES_TERMINATOR_MIDDLE : MESSAGES_TERMINATOR_END

                message_bytes << terminator

                null_pad = [MESSAGES_NULL] * (3 - message_packet.count)
                message_bytes.concat(null_pad)

                break if message_line_remaining.empty?
              end
            end
          end
        end

        private

        def metadata_bytes(activity_index)
          METADATA_BYTES_BASE + METADATA_BYTES_SIZE * activity_index
        end
      end
    end
  end
end
