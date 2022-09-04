# frozen_string_literal: true

class TimexDatalinkClient
  class WristApp
    prepend Crc
    include PaginateCpackets

    CPACKET_CLEAR = [0x93, 0x02]
    CPACKET_SECT = [0x90, 0x02]
    CPACKET_DATA = [0x91, 0x02]
    CPACKET_END = [0x92, 0x02]

    WRIST_APP_DELIMITER = /\xac.*\r\n/n
    WRIST_APP_CODE_INDEX = 8

    attr_accessor :wrist_app_data

    def initialize(wrist_app_data:)
      @wrist_app_data = wrist_app_data
    end

    def packets
      [CPACKET_CLEAR, cpacket_sect] + payloads + [CPACKET_END]
    end

    private

    def cpacket_sect
      CPACKET_SECT + [payloads.length, 1]
    end

    def wrist_app_ascii
      wrist_app_data.split(WRIST_APP_DELIMITER)[WRIST_APP_CODE_INDEX]
    end

    def wrist_app_bytes
      [wrist_app_ascii].pack("H*").bytes
    end

    def payloads
      paginate_cpackets(header: CPACKET_DATA, cpackets: wrist_app_bytes)
    end
  end
end
