# frozen_string_literal: true

require "timex_datalink_client/helpers/char_encoders"
require "timex_datalink_client/helpers/length_packet_wrapper"

class TimexDatalinkClient
  class Eeprom
    class List
      include Helpers::CharEncoders
      prepend Helpers::LengthPacketWrapper

      attr_accessor :list_entry, :priority

      def initialize(list_entry:, priority:)
        @list_entry = list_entry
        @priority = priority
      end

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
