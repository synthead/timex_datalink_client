# frozen_string_literal: true

class TimexDatalinkClient
  module CharEncoder
    CHARS = "0123456789abcdefghijklmnopqrstuvwxyz !\"#$%&'()*+,-./:\\;=@?ABCDEF"
    EEPROM_TERMINATOR = 0x3f

    PHONE_CHARS = "0123456789cfhpw "
    PHONE_DIGITS = 12

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
      padded_string_chars = string_chars.rjust(PHONE_DIGITS)
      truncated_string_chars = padded_string_chars[0..PHONE_DIGITS - 1]

      chars = chars_for(truncated_string_chars, char_map: PHONE_CHARS)

      packed_int = chars.each_with_index.sum do |char, index|
        char << (4 * index)
      end

      packed_int.digits(256)
    end
  end
end
