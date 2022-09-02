# frozen_string_literal: true

class TimexDatalinkClient
  module CharEncoder
    CHARS = "0123456789abcdefghijklmnopqrstuvwxyz !\"#$%&'()*+,-./:\\;=@?ABCDEF"

    def chars_for(string_chars)
      string_chars.each_char.map do |string_char|
        CHARS.index(string_char)
      end
    end
  end
end
