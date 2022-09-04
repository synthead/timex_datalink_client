# frozen_string_literal: true

require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class End
    prepend Helpers::CrcPacketsWrapper

    CPACKET_SKIP = [0x21]

    def packets
      [CPACKET_SKIP]
    end
  end
end
