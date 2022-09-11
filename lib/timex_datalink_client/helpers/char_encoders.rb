# frozen_string_literal: true

class TimexDatalinkClient
  class Helpers
    module CharEncoders
      CHARS = "0123456789abcdefghijklmnopqrstuvwxyz !\"#$%&'()*+,-./:\\;=@?_|<>[]"
      EEPROM_CHARS = "0123456789abcdefghijklmnopqrstuvwxyz !\"#$%&'()*+,-./:\\;=@?_|<>["
      PHONE_CHARS = "0123456789cfhpw "
      INVALID_CHAR = " "

      EEPROM_TERMINATOR = 0x3f

      def chars_for(string_chars, char_map: CHARS, length: nil, pad: false)
        formatted_chars = string_chars.downcase[0..length.to_i - 1]
        formatted_chars = formatted_chars.ljust(length) if pad

        formatted_chars.each_char.map do |char|
          char_map.index(char) || char_map.index(INVALID_CHAR)
        end
      end

      def eeprom_chars_for(string_chars)
        chars = chars_for(string_chars, char_map: EEPROM_CHARS, length: 31).append(EEPROM_TERMINATOR)

        packed_int = chars.each_with_index.sum do |char, index|
          char << (6 * index)
        end

        packed_int.digits(256)
      end

      def phone_chars_for(string_chars)
        chars = chars_for(string_chars, char_map: PHONE_CHARS, length: 12)

        packed_int = chars.each_with_index.sum do |char, index|
          char << (4 * index)
        end

        packed_int.digits(256)
      end
    end
  end
end
