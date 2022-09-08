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

    attr_accessor :spc_file

    # Create a SoundTheme instance.
    #
    # @param sound_theme_data [String, nil] Sound theme data.
    # @param spc_file [String, nil] Path to SPC file.
    # @return [SoundTheme] SoundTheme instance.
    def initialize(sound_theme_data: nil, spc_file: nil)
      @sound_theme_data = sound_theme_data
      @spc_file = spc_file
    end

    # Compile packets for a sound theme.
    #
    # @return [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
    def packets
      [load_sect] + payloads + [CPACKET_END]
    end

    private

    def load_sect
      CPACKET_SECT + [payloads.length, offset]
    end

    def payloads
      paginate_cpackets(header: CPACKET_DATA, cpackets: sound_theme_data.bytes)
    end

    def sound_theme_data
      @sound_theme_data || spc_file_data_without_header
    end

    def spc_file_data
      File.open(spc_file, "rb").read
    end

    def spc_file_data_without_header
      spc_file_data.delete_prefix(SOUND_DATA_HEADER)
    end

    def offset
      0x100 - sound_theme_data.bytesize
    end
  end
end
