# frozen_string_literal: true

class TimexDatalinkClient
  class End < Crc
    def render_without_crc
      "!"
    end
  end
end
