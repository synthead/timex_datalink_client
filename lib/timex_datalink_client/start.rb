# frozen_string_literal: true

require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Start
    prepend Helpers::CrcPacketsWrapper

    CPACKET_START = [0x20, 0x00, 0x00, 0x03]

    def packets
      [CPACKET_START]
    end
  end
end
