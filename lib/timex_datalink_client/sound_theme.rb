# frozen_string_literal: true

require "timex_datalink_client/helpers/cpacket_paginator"
require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class SoundTheme
    include Helpers::CpacketPaginator
    prepend Helpers::CrcPacketsWrapper

    CPACKET_SECT = [0x90, 0x03]
    CPACKET_DATA = [0x91, 0x03]
    CPACKET_END = [0x92, 0x03]

    SOUND_DATA_HEADER = "\x25\x04\x19\x69"

    attr_accessor :sound_data

    def initialize(sound_data:)
      @sound_data = sound_data
    end

    def packets
      [load_sect] + payloads + [CPACKET_END]
    end

    private

    def sound_bytes
      sound_data.delete_prefix(SOUND_DATA_HEADER).bytes
    end

    def load_sect
      CPACKET_SECT + [payloads.length, offset]
    end

    def payloads
      paginate_cpackets(header: CPACKET_DATA, cpackets: sound_bytes)
    end

    def offset
      0x100 - sound_bytes.length
    end
  end
end
