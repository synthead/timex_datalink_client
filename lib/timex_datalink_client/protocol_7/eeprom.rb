# frozen_string_literal: true

require "timex_datalink_client/helpers/cpacket_paginator"
require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Protocol7
    class Eeprom
      include Helpers::CpacketPaginator
      prepend Helpers::CrcPacketsWrapper

      CPACKET_SECT = [0x90, 0x05]
      CPACKET_DATA = [0x91, 0x05]
      CPACKET_END = [0x92, 0x05]

      CPACKET_SECT_WELCOME = [
        0x44, 0x53, 0x49, 0x20, 0x54, 0x6f, 0x79, 0x73, 0x20, 0x70, 0x72, 0x65, 0x73, 0x65, 0x6e, 0x74, 0x73, 0x2e,
        0x2e, 0x2e, 0x65, 0x42, 0x72, 0x61, 0x69, 0x6e, 0x21, 0x00, 0x00, 0x00, 0x00, 0x00
      ]

      CPACKET_DATA_LENGTH = 32

      attr_accessor :activities, :phone_numbers

      # Create an Eeprom instance.
      #
      # @param activities [Array<Activity>, nil] Activities to be added to EEPROM data.
      # @param phone_numbers [Array<Activity>, nil] Phone numbers to be added to EEPROM data.
      # @return [Eeprom] Eeprom instance.
      def initialize(activities: nil, phone_numbers: nil)
        @activities = activities
        @phone_numbers = phone_numbers
      end

      # Compile packets for EEPROM data.
      #
      # @return [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
      def packets
        [header] + payloads + [CPACKET_END]
      end

      private

      def header
        [
          CPACKET_SECT,
          payloads.length,
          CPACKET_SECT_WELCOME
        ].flatten
      end

      def payloads
        paginate_cpackets(header: CPACKET_DATA, length: CPACKET_DATA_LENGTH, cpackets: all_packets)
      end

      def all_packets
        [].tap do |packets|
          packets.concat(Activity.packets(activities)) if activities
          packets.concat(PhoneNumber.packets(phone_numbers)) if phone_numbers
        end
      end
    end
  end
end
