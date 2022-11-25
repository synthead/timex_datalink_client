# frozen_string_literal: true

class TimexDatalinkClient
  class Protocol7
    class Sync
      PING_BYTE = [0x78]
      SYNC_1_BYTE = [0x55]
      SYNC_2_BYTE = [0xaa]

      SYNC_2_LENGTH = 5

      attr_accessor :length

      # Create a Sync instance.
      #
      # @param length [Integer] Number of 0x55 sync bytes to use.
      # @return [Sync] Sync instance.
      def initialize(length: 300)
        @length = length
      end

      # Compile packets for syncronization data.
      #
      # @return [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
      def packets
        [PING_BYTE + render_sync_1 + render_sync_2]
      end

      private

      def render_sync_1
        SYNC_1_BYTE * length
      end

      def render_sync_2
        SYNC_2_BYTE * SYNC_2_LENGTH
      end
    end
  end
end
