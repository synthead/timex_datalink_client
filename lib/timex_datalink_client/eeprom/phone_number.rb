# frozen_string_literal: true

class TimexDatalinkClient
  class Eeprom
    class PhoneNumber
      include CharEncoder

      PHONE_DIGITS = 12

      attr_accessor :name, :number, :type

      def initialize(name:, number:, type: " ")
        @name = name
        @number = number
        @type = type
      end

      def packet
        [length, packet_array].flatten.pack("C*").force_encoding("UTF-8")
      end

      private

      def packet_array
        [
          number_with_type_characters,
          name_characters,
        ].flatten
      end

      def number_with_type_truncated
        number_with_type = "#{number} #{type}"
        padded_number_with_type = number_with_type.rjust(PHONE_DIGITS)

        padded_number_with_type[0..PHONE_DIGITS - 1]
      end

      def number_with_type_characters
        phone_chars_for(number_with_type_truncated)
      end

      def name_characters
        eeprom_chars_for(name)
      end

      def length
        packet_array.length + 1
      end
    end
  end
end
