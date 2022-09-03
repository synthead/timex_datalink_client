# frozen_string_literal: true

class TimexDatalinkClient
  module CharEncoder
    CHARS = "0123456789abcdefghijklmnopqrstuvwxyz !\"#$%&'()*+,-./:\\;=@?ABCDEF"
    EEPROM_TERMINATOR = 0x3f

    def chars_for(string_chars)
      string_chars.each_char.map do |string_char|
        CHARS.index(string_char)
      end
    end

    def eeprom_chars_for(string_chars)
      chars = chars_for(string_chars).append(EEPROM_TERMINATOR)

      packed_int = chars.each_with_index.sum do |char, index|
        char << (6 * index)
      end

      packed_int.digits(256)
    end
  end
end
