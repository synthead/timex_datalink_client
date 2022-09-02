# frozen_string_literal: true

class TimexDatalinkClient
  class Crc
    def render
      header + original_render + footer
    end

    private

    def original_render
      @original_render ||= render_without_crc
    end

    def header
      length = original_render.length + 3
      length.chr
    end

    def footer
      crc = CRC.crc16_arc(header + original_render)
      crc.divmod(256).pack("CC")
    end
  end
end
