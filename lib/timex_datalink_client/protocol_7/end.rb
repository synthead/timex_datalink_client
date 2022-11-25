# frozen_string_literal: true

require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Protocol7
    class End
      prepend Helpers::CrcPacketsWrapper

      SETUP_PACKET = [0x92, 0x05]
      CPACKET_SKIP = [0x21]

      # Compile packets for data end command.
      #
      # @return [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
      def packets
        [SETUP_PACKET, CPACKET_SKIP]
      end
    end
  end
end
