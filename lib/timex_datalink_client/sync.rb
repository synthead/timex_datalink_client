# frozen_string_literal: true

class TimexDatalinkClient
  class Sync
    SYNC_BYTE = "U"

    attr_accessor :length

    def initialize(length: 300)
      @length = length
    end

    def render
      SYNC_BYTE * length
    end
  end
end
