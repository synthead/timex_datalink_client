# frozen_string_literal: true

class TimexDatalinkClient
  class Eeprom
    class List
      prepend PrependLength
      include CharEncoder

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
