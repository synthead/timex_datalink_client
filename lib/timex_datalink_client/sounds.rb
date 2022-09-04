# frozen_string_literal: true

class TimexDatalinkClient
  class Sounds
    prepend Crc

    CLOAD_SECT_SOUND = [0x90, 0x03]
    CPACKET_DATA_SOUND = [0x91, 0x03]
    CPACKET_END_SOUND = [0x92, 0x03]

    SOUND_FILE_HEADER = "\x25\x04\x19\x69"
    ITEMS_PER_PACKET = 32

    attr_accessor :sound_data

    def initialize(sound_data:)
      @sound_data = sound_data
    end

    def packets
      [load_sect] + payloads + [CPACKET_END_SOUND]
    end

    private

    def sound_bytes
      sound_data.delete_prefix(SOUND_FILE_HEADER).bytes
    end

    def load_sect
      CLOAD_SECT_SOUND + [payloads.length, offset]
    end

    def payloads
      paginated_packets = sound_bytes.each_slice(ITEMS_PER_PACKET)

      paginated_packets.map.with_index(1) do |paginated_packet, index|
        CPACKET_DATA_SOUND + [index] + paginated_packet
      end
    end

    def offset
      0x100 - sound_bytes.length
    end
  end
end
