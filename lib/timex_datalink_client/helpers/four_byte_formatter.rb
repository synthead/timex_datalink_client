# frozen_string_literal: true

class TimexDatalinkClient
  class Helpers
    module FourByteFormatter
      PACKET_PREFIX_EMPTY = 0xc0
      PACKET_PREFIX_FULL = 0x00
      PACKET_PREFIXES_DEFAULT = [0x30, 0x0c, 0x03, PACKET_PREFIX_FULL]

      BYTE_NULL = 0x00
      BYTE_TERMINATOR_MIDDLE = 0xfe
      BYTE_TERMINATOR_END = 0xff

      def four_byte_format_for(byte_arrays, packet_prefixes: nil)
        [].tap do |formatted_bytes|
          packet_prefixes_remaining = packet_prefixes.dup

          byte_arrays.each_with_index do |byte_array, byte_array_index|
            byte_array_remaining = byte_array.dup

            loop do
              byte_packet = byte_array_remaining.shift(4)

              packet_prefix = if byte_packet.empty?
                PACKET_PREFIX_EMPTY
              else
                packet_prefixes ? packet_prefixes_remaining.shift : PACKET_PREFIXES_DEFAULT[byte_packet.count - 1]
              end

              formatted_bytes << packet_prefix

              formatted_bytes.concat(byte_packet)

              next if byte_packet.count == 4

              has_next_line = byte_arrays[byte_array_index + 1]
              terminator = has_next_line ? BYTE_TERMINATOR_MIDDLE : BYTE_TERMINATOR_END

              formatted_bytes << terminator

              null_pad = [BYTE_NULL] * (3 - byte_packet.count)
              formatted_bytes.concat(null_pad)

              break if byte_array_remaining.empty?
            end
          end
        end
      end
    end
  end
end
