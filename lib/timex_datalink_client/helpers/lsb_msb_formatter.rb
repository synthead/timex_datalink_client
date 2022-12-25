# frozen_string_literal: true

class TimexDatalinkClient
  class Helpers
    module LsbMsbFormatter
      def lsb_msb_format_for(value)
        value.divmod(256).reverse
      end
    end
  end
end
