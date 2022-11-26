# frozen_string_literal: true

require "timex_datalink_client/helpers/four_byte_formatter"

class TimexDatalinkClient
  class Protocol7
    class Eeprom
      class PhoneNumber
        include Helpers::FourByteFormatter

        PHONE_NUMBER_DIGITS_MAP = {
          "0" => 0x01,
          "1" => 0x02,
          "2" => 0x03,
          "3" => 0x04,
          "4" => 0x05,
          "5" => 0x06,
          "6" => 0x07,
          "7" => 0x08,
          "8" => 0x09,
          "9" => 0x0a
        }.freeze

        PACKETS_TERMINATOR = 0x03

        # Compile data for all phone numbers.
        #
        # @param phone_numbers [Array<PhoneNumber>] Phone numbers to compile data for.
        # @return [Array] Compiled data of all phone numbers.
        def self.packets(phone_numbers)
          header(phone_numbers) + names_and_numbers(phone_numbers) + [PACKETS_TERMINATOR]
        end

        private_class_method def self.header(phone_numbers)
          [
            phone_numbers.count,
            0
          ]
        end

        private_class_method def self.names_and_numbers(phone_numbers)
          names_and_numbers = phone_numbers.flat_map(&:name_and_number)

          phone_numbers.first.four_byte_format_for(names_and_numbers)
        end

        attr_accessor :name, :number

        # Create a PhoneNumber instance.
        #
        # @param name [Array<Integer>] Name associated to phone number.
        # @param number [String] Phone number text.
        # @return [PhoneNumber] PhoneNumber instance.
        def initialize(name: [], number:)
          @name = name
          @number = number
        end

        # Compile an unformatted name and phone number.
        #
        # @return [Array<Integer>] Array of integers that represent bytes.
        def name_and_number
          [
            name,
            number_characters
          ]
        end

        private

        def number_characters
          number.each_char.map { |digit| PHONE_NUMBER_DIGITS_MAP[digit] }
        end
      end
    end
  end
end
