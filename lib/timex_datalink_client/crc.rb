# frozen_string_literal: true

class TimexDatalinkClient
  module Crc
    attr_reader :render_without_crc

    def render
      @render_without_crc = super

      crc_header + render_without_crc + crc_footer
    end

    private

    def crc_header
      length = render_without_crc.length + 3
      length.chr
    end

    def crc_footer
      crc = CRC.crc16_arc(crc_header + render_without_crc)
      crc.divmod(256).pack("CC")
    end
  end
end
