# frozen_string_literal: true

class TimexDatalinkClient
  module PaginateCpackets
    ITEMS_PER_PACKET = 32

    def paginate_cpackets(header:, cpackets:)
      paginated_cpackets = cpackets.each_slice(ITEMS_PER_PACKET)

      paginated_cpackets.map.with_index(1) do |paginated_cpacket, index|
        header + [index] + paginated_cpacket
      end
    end
  end
end
