# frozen_string_literal: true

require "timex_datalink_client/helpers/char_encoders"
require "timex_datalink_client/helpers/length_packet_wrapper"

class TimexDatalinkClient
  class Protocol6
    class Eeprom
      class PhoneNumber
        include Helpers::CharEncoders
        prepend Helpers::LengthPacketWrapper

        PHONE_DIGITS = 12
        NAME_MAX_LENGTH = 31

        NUMBER_NAME_DELIMITER = "-"
        NUMBER_NAME_MAX_NUMBER_LENGTH = 30

        TERMINATOR = 0x5c

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
            name_characters,
            TERMINATOR
          ].flatten
        end

        private

        def number_with_type_characters
          phone_chars_for(number_with_type_padded)
        end

        def name_characters
          return protocol_6_chars_for(name_with_number) if number.length > PHONE_DIGITS

          protocol_6_chars_for(name, length: NAME_MAX_LENGTH)
        end

        def number_with_type_padded
          number_with_type = "#{number} #{type}"
          number_with_type.rjust(PHONE_DIGITS)
        end

        def name_with_number
          number_name = NUMBER_NAME_DELIMITER
          number_name += number[PHONE_DIGITS..NUMBER_NAME_MAX_NUMBER_LENGTH - 1]

          name_length = NUMBER_NAME_MAX_NUMBER_LENGTH - number_name.length
          truncated_name = name[..name_length - 1]

          "#{truncated_name}#{number_name}"
        end
      end
    end
  end
end
