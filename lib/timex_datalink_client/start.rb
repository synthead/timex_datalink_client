# frozen_string_literal: true

class TimexDatalinkClient
  class Start < Crc
    def render_without_crc
      " \0\0\03"
    end
  end
end
