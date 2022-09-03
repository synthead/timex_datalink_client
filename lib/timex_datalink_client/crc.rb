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
      length = packet.length + 3
      length.chr
    end

    def crc_footer(packet)
      crc = CRC.crc16_arc(crc_header(packet) + packet)
      crc.divmod(256).pack("CC")
    end
  end
end
