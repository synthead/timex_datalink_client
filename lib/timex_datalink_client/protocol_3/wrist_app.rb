# frozen_string_literal: true

require "timex_datalink_client/helpers/cpacket_paginator"
require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Protocol3
    class WristApp
      include Helpers::CpacketPaginator
      prepend Helpers::CrcPacketsWrapper

      CPACKET_CLEAR = [0x93, 0x02]
      CPACKET_SECT = [0x90, 0x02]
      CPACKET_DATA = [0x91, 0x02]
      CPACKET_END = [0x92, 0x02]

      CPACKET_DATA_LENGTH = 32
      WRIST_APP_DELIMITER = /\xac.*\r\n/n
      WRIST_APP_CODE_INDEX = 8

      attr_accessor :zap_file

      # Create a WristApp instance.
      #
      # @param wrist_app_data [String, nil] WristApp data.
      # @param zap_file [String, nil] Path to ZAP file.
      # @return [WristApp] WristApp instance.
      def initialize(wrist_app_data: nil, zap_file: nil)
        @wrist_app_data = wrist_app_data
        @zap_file = zap_file
      end

      # Compile packets for an alarm.
      #
      # @return [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
      def packets
        [CPACKET_CLEAR, cpacket_sect] + payloads + [CPACKET_END]
      end

      private

      def cpacket_sect
        CPACKET_SECT + [payloads.length, 1]
      end

      def payloads
        paginate_cpackets(header: CPACKET_DATA, length: CPACKET_DATA_LENGTH, cpackets: wrist_app_data.bytes)
      end

      def wrist_app_data
        @wrist_app_data || zap_file_data_binary
      end

      def zap_file_data
        File.open(zap_file, "rb").read
      end

      def zap_file_data_ascii
        zap_file_data.split(WRIST_APP_DELIMITER)[WRIST_APP_CODE_INDEX]
      end

      def zap_file_data_binary
        [zap_file_data_ascii].pack("H*")
      end
    end
  end
end
