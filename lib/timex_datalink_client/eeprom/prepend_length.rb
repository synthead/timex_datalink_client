# frozen_string_literal: true

class TimexDatalinkClient
  class Eeprom
    module PrependLength
      def packet
        [super.length + 1] + super
      end
    end
  end
end
