# frozen_string_literal: true

class TimexDatalinkClient
  class Start
    prepend Crc

    def packets
      [
        [0x20, 0x00, 0x00, 0x03]
      ]
    end
  end
end
