# frozen_string_literal: true

class TimexDatalinkClient
  class Eeprom
    class PhoneNumber
      include CharEncoder

      NUMBER_LENGTH_ADD_TYPE = 10

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
          number_characters,
          name_characters,
        ].flatten
      end

      def number_with_type
        "#{number} #{type}"
      end

      def number_characters
        phone_chars_for(number_with_type)
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
