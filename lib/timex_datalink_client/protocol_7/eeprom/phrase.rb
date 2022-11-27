# frozen_string_literal: true

require "timex_datalink_client/helpers/four_byte_formatter"

class TimexDatalinkClient
  class Protocol7
    class Eeprom
      class Phrase
        include Helpers::FourByteFormatter

        METADATA_BYTES_BASE = 0x0b
        METADATA_BYTES_SIZE = 5

        HEADER_BOOL_TRUE_VALUE = 0x1a
        HEADER_BOOL_FALSE_VALUE = 0x00
        HEADER_ONE_BYTE_VALUE_BASE = 0x0b
        HEADER_TWO_BYTE_VALUES_BASE = [0x1a, 0x24, 0x2e, 0x38, 0x47, 0x56, 0x60, 0x6a, 0x6f, 0x79, 0x83]
        HEADER_TWO_BYTE_LOOP_BASE = 0x8d

        HEADER_FOOTER = [
          0xf0, 0x53, 0xfd, 0x4d, 0x03, 0xb0, 0x8d, 0xfe, 0x00, 0x00, 0xf0, 0x53, 0xfd, 0x4d, 0x03, 0xb0, 0x7b, 0xfe,
          0x00, 0x00, 0xf0, 0xfb, 0x63, 0x39, 0x3c, 0xc0, 0xfe, 0x00, 0x00, 0x00, 0xf0, 0xfb, 0x61, 0x39, 0x3c, 0x70,
          0x94, 0xfd, 0x4b, 0x03, 0x7c, 0x44, 0x27, 0xfe, 0x00, 0xd3, 0xfb, 0xae, 0x30, 0x29, 0x33, 0x3c, 0xfb, 0x30,
          0x20, 0x07, 0x3c, 0x39, 0x24, 0xfe, 0xf1, 0xfb, 0x53, 0x03, 0xae, 0x9c, 0xe6, 0x8e, 0xfe, 0x00, 0xc1, 0x61,
          0x39, 0x3c, 0x44, 0xcc, 0xfd, 0x4b, 0xfe, 0x00, 0xff, 0xfb, 0x61, 0x3e, 0xfe, 0x41, 0xcb, 0x39, 0x3c, 0x44,
          0xcc, 0xfd, 0x4b, 0xfe, 0x00, 0x37, 0x39, 0x5a, 0xae, 0xfd, 0x1f, 0x4b, 0x8e, 0x81, 0xfe, 0x3f, 0x39, 0x5a,
          0x1c, 0x81, 0xc0, 0xff, 0x00, 0x00, 0x00
        ]

        PACKETS_TERMINATOR = 0x05

        # Compile data for all phrases.
        #
        # @param phrases [Array<Phrase>] Phrases to compile data for.
        # @return [Array] Compiled data of all phrases.
        def self.packets(phrases)
          header(phrases) + formatted_phrases(phrases) + [PACKETS_TERMINATOR]
        end

        private_class_method def self.header(phrases)
          bool_value = phrases.empty? ? HEADER_BOOL_FALSE_VALUE : HEADER_BOOL_TRUE_VALUE

          one_byte_value = HEADER_ONE_BYTE_VALUE_BASE + phrases.count

          two_byte_values = HEADER_TWO_BYTE_VALUES_BASE.flat_map do |value_base|
            value = value_base + phrases.count * 2
            value.divmod(256).reverse
          end

          loop_values = phrases.each_index.flat_map do |phrase_index|
            value = HEADER_TWO_BYTE_LOOP_BASE + phrases.count * 2 + phrase_index * 5
            value.divmod(256).reverse
          end

          [
            one_byte_value,
            0,
            bool_value,
            0,
            two_byte_values,
            loop_values,
            HEADER_FOOTER
          ].flatten
        end

        private_class_method def self.formatted_phrases(phrases)
          return [] if phrases.empty?

          phrases_bytes = phrases.map(&:phrase)
          phrases.first.four_byte_format_for(phrases_bytes)
        end

        attr_accessor :phrase

        # Create a Phrase instance.
        #
        # @param phrase [Array<Integer>] Phrase for phrase.
        # @return [Phrase] Phrase instance.
        def initialize(phrase:)
          @phrase = phrase
        end
      end
    end
  end
end
