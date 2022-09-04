# frozen_string_literal: true

class TimexDatalinkClient
  class Eeprom
    class List
      include CharEncoder

      attr_accessor :list_entry, :priority

      def initialize(list_entry:, priority:)
        @list_entry = list_entry
        @priority = priority
      end

      def packet
        [length] + packet_array
      end

      private

      def packet_array
        [
          priority,
          list_entry_characters
        ].flatten
      end

      def list_entry_characters
        eeprom_chars_for(list_entry)
      end

      def length
        packet_array.length + 1
      end
    end
  end
end
