# frozen_string_literal: true

class TimexDatalinkClient
  class End
    prepend Crc

    CPACKET_SKIP = [0x21]

    def packets
      [CPACKET_SKIP]
    end
  end
end
