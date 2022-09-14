# frozen_string_literal: true

require "timex_datalink_client/helpers/char_encoders"
require "timex_datalink_client/helpers/length_packet_wrapper"

class TimexDatalinkClient
  class Eeprom
    class PhoneNumber
      include Helpers::CharEncoders
      prepend Helpers::LengthPacketWrapper

      PHONE_DIGITS = 12

      attr_accessor :name, :number, :type

      # Create a PhoneNumber instance.
      #
      # @param name [String] Name associated to phone number.
      # @param number [String] Phone number text.
      # @param type [String] Phone number type.
      # @return [PhoneNumber] PhoneNumber instance.
      def initialize(name:, number:, type: " ")
        @name = name
        @number = number
        @type = type
      end

      # Compile a packet for a phone number.
      #
      # @return [Array<Integer>] Array of integers that represent bytes.
      def packet
        [
          number_with_type_characters,
          name_characters
        ].flatten
      end

      private

      def number_with_type_padded
        number_with_type = "#{number} #{type}"
        number_with_type.rjust(PHONE_DIGITS)
      end

      def number_with_type_characters
        phone_chars_for(number_with_type_padded)
      end

      def name_characters
        eeprom_chars_for(name)
      end
    end
  end
end
