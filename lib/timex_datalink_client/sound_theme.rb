# frozen_string_literal: true

class TimexDatalinkClient
  class SoundTheme
    prepend Crc
    include PaginateCpackets

    CLOAD_SECT_SOUND = [0x90, 0x03]
    CPACKET_DATA_SOUND = [0x91, 0x03]
    CPACKET_END_SOUND = [0x92, 0x03]

    SOUND_FILE_HEADER = "\x25\x04\x19\x69"

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
      paginate_cpackets(header: CPACKET_DATA_SOUND, cpackets: sound_bytes)
    end

    def offset
      0x100 - sound_bytes.length
    end
  end
end
