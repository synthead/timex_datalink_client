# frozen_string_literal: true

class TimexDatalinkClient
  class Helpers
    module CpacketPaginator
      def paginate_cpackets(header:, length:, cpackets:)
        paginated_cpackets = cpackets.each_slice(length)

        paginated_cpackets.map.with_index(1) do |paginated_cpacket, index|
          header + [index] + paginated_cpacket
        end
      end
    end
  end
end
