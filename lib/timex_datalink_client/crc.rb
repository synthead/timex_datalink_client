# frozen_string_literal: true

class TimexDatalinkClient
  module Crc
    def packets
      super.map do |packet|
        crc_header(packet) + packet + crc_footer(packet)
      end
    end

    private

    def crc_header(packet)
      [packet.length + 3]
    end

    def crc_footer(packet)
      crc_check = (crc_header(packet) + packet).pack("C*")
      crc = CRC.crc16_arc(crc_check)

      crc.divmod(256)
    end
  end
end
