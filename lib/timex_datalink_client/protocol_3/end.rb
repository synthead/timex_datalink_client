# frozen_string_literal: true

require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Protocol3
    class End
      prepend Helpers::CrcPacketsWrapper

      CPACKET_SKIP = [0x21]

      # Compile packets for data end command.
      #
      # @return [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
      def packets
        [CPACKET_SKIP]
      end
    end
  end
end
