# frozen_string_literal: true

require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Protocol7
    class Start
      prepend Helpers::CrcPacketsWrapper

      CPACKET_START = [0x20, 0x00, 0x00, 0x07]

      # Compile packets for data start command.
      #
      # @return [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
      def packets
        [CPACKET_START]
      end
    end
  end
end
