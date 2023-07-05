# frozen_string_literal: true

require "active_model"

require "timex_datalink_client/helpers/cpacket_paginator"
require "timex_datalink_client/helpers/crc_packets_wrapper"
require "timex_datalink_client/helpers/lsb_msb_formatter"

class TimexDatalinkClient
  class Protocol6
    class Eeprom
      include ActiveModel::Validations
      include Helpers::CpacketPaginator
      include Helpers::LsbMsbFormatter
      prepend Helpers::CrcPacketsWrapper

      CPACKET_CLEAR = [0x93, 0x01]
      CPACKET_SECT = [0x90, 0x01]
      CPACKET_DATA = [0x91, 0x01]
      CPACKET_END = [0x92, 0x01]

      CPACKET_DATA_LENGTH = 32

      attr_accessor :phone_numbers

      # Create an Eeprom instance.
      #
      # @param phone_numbers [Array<PhoneNumber>] Phone numbers to be added to EEPROM data.
      # @return [Eeprom] Eeprom instance.
      def initialize(phone_numbers: [])
        @phone_numbers = phone_numbers
      end

      # Compile packets for EEPROM data.
      #
      # @raise [ActiveModel::ValidationError] One or more model values are invalid.
      # @return [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
      def packets
        validate!

        [CPACKET_CLEAR, header] + payloads + [CPACKET_END]
      end

      private

      def header
        [
          CPACKET_SECT,
          payloads_length,
          0x04,
          phone_numbers_length,
        ].flatten
      end

      def payloads
        paginate_cpackets(header: CPACKET_DATA, length: CPACKET_DATA_LENGTH, cpackets: all_packets)
      end

      def all_packets
        phone_numbers.map(&:packet).flatten
      end

      def payloads_length
        lsb_msb_format_for(payloads.length)
      end

      def phone_numbers_length
        length_lsb = lsb_msb_format_for(phone_numbers.length).first

        [length_lsb, 0]
      end
    end
  end
end
