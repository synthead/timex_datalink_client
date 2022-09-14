# frozen_string_literal: true

require "timex_datalink_client/helpers/char_encoders"
require "timex_datalink_client/helpers/length_packet_wrapper"

class TimexDatalinkClient
  class Protocol1
    class Eeprom
      class List
        include Helpers::CharEncoders
        prepend Helpers::LengthPacketWrapper

        attr_accessor :list_entry, :priority

        # Create a List instance.
        #
        # @param list_entry [String] List entry text.
        # @param priority [Integer] List priority.
        # @return [List] List instance.
        def initialize(list_entry:, priority:)
          @list_entry = list_entry
          @priority = priority
        end

        # Compile a packet for a list.
        #
        # @return [Array<Integer>] Array of integers that represent bytes.
        def packet
          [
            priority,
            list_entry_characters
          ].flatten
        end

        private

        def list_entry_characters
          eeprom_chars_for(list_entry)
        end
      end
    end
  end
end
