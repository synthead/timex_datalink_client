# frozen_string_literal: true

class TimexDatalinkClient
  class Helpers
    module LengthPacketWrapper
      def packet
        [super.length + 1] + super
      end
    end
  end
end
