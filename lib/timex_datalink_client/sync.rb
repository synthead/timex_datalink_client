# frozen_string_literal: true

class TimexDatalinkClient
  class Sync
    SYNC_1_BYTE = [0x55]
    SYNC_2_BYTE = [0xaa]
    SYNC_2_LENGTH = 40

    attr_accessor :length

    def initialize(length: 300)
      @length = length
    end

    def packets
      [render_sync_1 + render_sync_2]
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
