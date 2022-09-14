# frozen_string_literal: true

require "timex_datalink_client/helpers/cpacket_paginator"
require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Protocol9
    class Eeprom
      include Helpers::CpacketPaginator
      prepend Helpers::CrcPacketsWrapper

      CPACKET_MEM = [0x70]
      CPACKET_JMPMEM = [0x23]
      CPACKET_SECT = [0x60]
      CPACKET_DATA = [0x61]
      CPACKET_END = [0x62]

      SETUP_PACKETS = [
        CPACKET_MEM + [
          0x02, 0x40, 0x05, 0xa9, 0x22, 0x5f, 0xe6, 0xb2, 0xe8, 0xbb, 0xe7, 0xb2, 0xe8, 0xbb, 0xe7, 0xbb, 0xe8, 0xb2,
          0xe7, 0xb2, 0x5c, 0xa3, 0x09, 0x26, 0xed, 0x15, 0xa9, 0x01
        ],
        CPACKET_MEM + [0x02, 0x5a, 0xa9, 0x02, 0x14, 0xa9, 0xb6, 0xa9, 0xa4, 0x07, 0x47, 0xb7, 0xa9, 0xcc, 0x74, 0x6f],
        CPACKET_JMPMEM + [0x02, 0x40]
      ]

      PAYLOAD_HEADER = [0x00, 0x0e, 0x00]

      CPACKET_DATA_LENGTH = 27
      START_INDEX = 14
      APPOINTMENT_NO_NOTIFICATION = 0xff

      def self.empty_chrono
        Chrono.new(label: "chrono", laps: 2)
      end

      attr_accessor :chrono, :phone_numbers

      # Create an Eeprom instance.
      #
      # @param chrono [Chrono] Chrono to be added to EEPROM data.
      # @param phone_numbers [Array<PhoneNumber>] Phone numbers to be added to EEPROM data.
      # @return [Eeprom] Eeprom instance.
      def initialize(chrono: nil, phone_numbers: [])
        @chrono = chrono || self.class.empty_chrono
        @phone_numbers = phone_numbers
      end

      # Compile packets for EEPROM data.
      #
      # @return [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
      def packets
        SETUP_PACKETS + [header] + payloads + [CPACKET_END]
      end

      private

      def header
        CPACKET_SECT + [payloads.length]
      end

      def payload
        [
          PAYLOAD_HEADER,
          chrono.chrono_bytesize,
          chrono.laps,
          phone_numbers.length,
          all_packets
        ].flatten
      end

      def payloads
        paginate_cpackets(header: CPACKET_DATA, length: CPACKET_DATA_LENGTH, cpackets: payload)
      end

      def all_items
        [[chrono], phone_numbers]
      end

      def all_packets
        all_items.flatten.map(&:packet).flatten
      end
    end
  end
end
