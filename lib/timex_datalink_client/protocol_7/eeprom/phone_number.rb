# frozen_string_literal: true

require "timex_datalink_client/helpers/four_byte_formatter"

class TimexDatalinkClient
  class Protocol7
    class Eeprom
      class PhoneNumber
        include Helpers::FourByteFormatter

        PHONE_NUMBER_DIGITS_MAP = {
          "0" => 0x001,
          "1" => 0x002,
          "2" => 0x003,
          "3" => 0x004,
          "4" => 0x005,
          "5" => 0x006,
          "6" => 0x007,
          "7" => 0x008,
          "8" => 0x009,
          "9" => 0x00a
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
          return [] if phone_numbers.empty?

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
