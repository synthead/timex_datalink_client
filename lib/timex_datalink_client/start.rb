# frozen_string_literal: true

class TimexDatalinkClient
  class Start
    prepend Crc

    def render
      " \0\0\03"
    end
  end
end
