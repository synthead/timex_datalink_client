# frozen_string_literal: true

class TimexDatalinkClient
  class Helpers
    module FourByteFormatter
      BYTE_NULL = 0x000
      BYTE_TERMINATOR_ENDF = 0x3fe
      BYTE_TERMINATOR_ENDR = 0x3ff

      def four_byte_format_for(byte_arrays)
        byte_arrays.each_with_index.flat_map do |bytes, bytes_index|
          last_index = bytes_index == byte_arrays.count - 1
          terminator = last_index ? BYTE_TERMINATOR_ENDR : BYTE_TERMINATOR_ENDF

          bytes_with_terminator = bytes + [terminator]

          bytes_with_terminator.each_slice(4).flat_map do |bytes_slice|
            bytes_slice.fill(BYTE_NULL, bytes_slice.count, 4 - bytes_slice.count)

            packet_lsbs_sum = bytes_slice.each_with_index.sum { |byte, index| byte / 256 << 6 - index * 2 }
            packet_msbs = bytes_slice.map { |byte| byte % 256 }

            [packet_lsbs_sum] + packet_msbs
          end
        end
      end
    end
  end
end
