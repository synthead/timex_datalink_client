# frozen_string_literal: true

class TimexDatalinkClient
  class End
    prepend Crc

    def packets
      [
        [0x21]
      ]
    end
  end
end
