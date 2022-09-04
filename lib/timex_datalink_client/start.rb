# frozen_string_literal: true

class TimexDatalinkClient
  class Start
    prepend Crc

    CPACKET_START = [0x20, 0x00, 0x00, 0x03]

    def packets
      [CPACKET_START]
    end
  end
end
