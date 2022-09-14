# frozen_string_literal: true

require "timex_datalink_client/helpers/char_encoders"
require "timex_datalink_client/helpers/length_packet_wrapper"

class TimexDatalinkClient
  class Protocol9
    class Eeprom
      class PhoneNumber
        include Helpers::CharEncoders
        prepend Helpers::LengthPacketWrapper

        NAME_CHARS = 15
        PHONE_DIGITS = 12
        TYPE_DIGITS = 2

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

        def number_with_type_characters
          phone_chars_for(number_with_type_padded)
        end

        def name_characters
          eeprom_chars_for(name_with_number_rollover, length: NAME_CHARS)
        end

        def number_with_type_padded
          type_padded = type.rjust(TYPE_DIGITS)
          number_with_type = "#{number}#{type_padded}"

          number_with_type.rjust(PHONE_DIGITS)
        end

        def number_rollover
          "-" + number[PHONE_DIGITS..]
        end

        def name_with_number_rollover
          return name unless number.length > PHONE_DIGITS

          truncate_length = NAME_CHARS - (name.length + number_rollover.length)

          return "#{name}#{number_rollover}" unless truncate_length.negative?

          "#{name[..truncate_length - 1]}#{number_rollover}"
        end
      end
    end
  end
end
