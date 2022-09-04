# frozen_string_literal: true

class TimexDatalinkClient
  class Helpers
    module CharEncoders
      CHARS = "0123456789abcdefghijklmnopqrstuvwxyz !\"#$%&'()*+,-./:\\;=@?ABCDEF"
      EEPROM_TERMINATOR = 0x3f

      PHONE_CHARS = "0123456789cfhpw "

      def chars_for(string_chars, char_map: CHARS)
        string_chars.each_char.map do |string_char|
          char_map.index(string_char)
        end
      end

      def eeprom_chars_for(string_chars)
        chars = chars_for(string_chars).append(EEPROM_TERMINATOR)

        packed_int = chars.each_with_index.sum do |char, index|
          char << (6 * index)
        end

        packed_int.digits(256)
      end

      def phone_chars_for(string_chars)
        chars = chars_for(string_chars, char_map: PHONE_CHARS)

        packed_int = chars.each_with_index.sum do |char, index|
          char << (4 * index)
        end

        packed_int.digits(256)
      end
    end
  end
end
