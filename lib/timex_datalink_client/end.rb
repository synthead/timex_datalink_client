# frozen_string_literal: true

class TimexDatalinkClient
  class End
    prepend Crc

    def packets
      ["!"]
    end
  end
end
