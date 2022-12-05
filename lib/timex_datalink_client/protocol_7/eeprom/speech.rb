# frozen_string_literal: true

require "timex_datalink_client/helpers/four_byte_formatter"

class TimexDatalinkClient
  class Protocol7
    class Eeprom
      class Speech
        include Helpers::FourByteFormatter

        NICKNAME_LENGTH_WITHOUT_DEVICE = 10
        NICKNAME_LENGTH_WITH_DEVICE = 14

        NICKNAME_SUFFIXES = [
          [0x353, 0x3fd, 0x04d, 0x003, 0x28d],
          [0x353, 0x3fd, 0x04d, 0x003, 0x27b],
          [0x3fb, 0x363, 0x039, 0x03c],
          [0x3fb, 0x361, 0x039, 0x03c, 0x194, 0x3fd, 0x04b, 0x003, 0x144, 0x327],
          [0x3fb, 0x1ae, 0x030, 0x329, 0x03c, 0x3fb, 0x030, 0x320, 0x03c, 0x039, 0x124],
          [0x3fb, 0x353, 0x003, 0x1ae, 0x2e6, 0x18e],
          [0x361, 0x039, 0x03c, 0x144, 0x3fd, 0x04b],
          [0x3fb, 0x361, 0x33e],
          [0x1cb, 0x039, 0x03c, 0x144, 0x3fd, 0x04b],
          [0x039, 0x35a, 0x1ae, 0x3fd, 0x04b, 0x18e, 0x381],
          [0x039, 0x35a, 0x31c, 0x381],
          [0x353, 0x3fd, 0x04d, 0x003, 0x28d, 0x07b, 0x094],
          [0x1e0, 0x1ab],
          [0x253, 0x3fd, 0x04d, 0x182],
          [0x353, 0x3fd, 0x04d, 0x003, 0x357, 0x10c, 0x3fd, 0x04d]
        ]

        HEADER_VALUE_1_BASE = 0x0b
        HEADER_VALUE_1_DEVICE_NICK = 4

        HEADER_VALUE_2_BASE = 0x00
        HEADER_VALUE_2_PHRASES = 26
        HEADER_VALUE_2_DEVICE_NICK = 8

        HEADER_VALUE_3_BASE = 0x1a
        HEADER_VALUE_3_PHRASES = 2
        HEADER_VALUE_3_DEVICE_NICK = 8

        HEADER_VALUE_4_DEVICE_BASE = 8
        HEADER_VALUE_4_PHRASE = 2

        HEADER_VALUE_4_BASES = [0x1a, 0x1a, 0x1a, 0x1f, 0x1a, 0x1a, 0x1a, 0x1a, 0x1a, 0x1a, 0x1a, 0x1a, 0x1a, 0x1a]
        HEADER_VALUE_4_DEVICE_MULTIPLIERS = [5, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 5, 5, 5]

        HEADER_VALUE_4_DEVICE_INDEXES = [
          [0],
          [0],
          [0],
          [0],
          [0],
          [0],
          [0],
          [0],
          [0],
          [0],
          [0],
          [0, 1, 11],
          [0, 1, 11, 12],
          [0, 1, 11, 12, 13]
        ]

        HEADER_VALUE_4_USER_MULTIPLIERS = [0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5]

        HEADER_VALUE_4_USER_INDEXES = [
          [],
          [],
          [2],
          [2, 5],
          [3, 4, 10],
          [3, 4, 5, 10],
          [3, 4, 5, 6, 10],
          [3, 4, 5, 6, 7, 10],
          [3, 4, 5, 6, 7, 8, 10],
          [3, 4, 5, 6, 7, 8, 9, 10],
          [2, 3, 4, 5, 6, 7, 8, 9, 10],
          [2, 3, 4, 5, 6, 7, 8, 9, 10],
          [2, 3, 4, 5, 6, 7, 8, 9, 10],
          [2, 3, 4, 5, 6, 7, 8, 9, 10]
        ]

        HEADER_VALUE_5_BASE = 0x8d

        HEADER_VALUE_5_DEVICE_BASE = -107
        HEADER_VALUE_5_DEVICE_INDEXES = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
        HEADER_VALUE_5_DEVICE_MULTIPLIER = 5

        HEADER_VALUE_5_USER_BASE = 0
        HEADER_VALUE_5_USER_INDEXES = [14]
        HEADER_VALUE_5_USER_MULTIPLIER = 5

        HEADER_VALUE_5_PHRASE = 2
        HEADER_VALUE_5_PHRASE_PACKET = 5

        PACKETS_TERMINATOR = 0x05

        attr_accessor :phrases, :device_nickname, :user_nickname

        # Create a Speech instance.
        #
        # @param phrases [Array<Array<Integer>>] Two-dimensional array of phrases.
        # @param device_nickname [Array<Integer>] Device nickname.
        # @param user_nickname [Array<Integer>] User nickname.
        # @return [Speech] Speech instance.
        def initialize(phrases: [], device_nickname: [], user_nickname: [])
          @phrases = phrases
          @device_nickname = device_nickname
          @user_nickname = user_nickname
        end

        # Compile data for nicknames and phrases.
        #
        # @return [Array<Integer>] Compiled data of all nicknames and phrases.
        def packets
          header + nickname_bytes + formatted_phrases + [PACKETS_TERMINATOR]
        end

        private

        def header
          all_values = [header_value_1, header_value_2, header_value_3] + header_values_4 + header_values_5

          all_values.flat_map { |value| value.divmod(256).reverse }
        end

        def header_value_1
          value_1 = HEADER_VALUE_1_BASE + phrases.count
          value_1 += HEADER_VALUE_1_DEVICE_NICK if device_nickname.any?

          value_1
        end

        def header_value_2
          value_2 = HEADER_VALUE_2_BASE
          value_2 += HEADER_VALUE_2_PHRASES if phrases.any?
          value_2 += HEADER_VALUE_2_DEVICE_NICK if phrases.any? && device_nickname.any?

          value_2
        end

        def header_value_3
          value_3 = HEADER_VALUE_3_BASE
          value_3 += HEADER_VALUE_3_DEVICE_NICK if device_nickname.any?
          value_3 += HEADER_VALUE_3_PHRASES * phrases.count

          value_3
        end

        def header_values_4
          value_4_length = device_nickname.any? ? NICKNAME_LENGTH_WITH_DEVICE : NICKNAME_LENGTH_WITHOUT_DEVICE

          value_4_length.times.flat_map do |value_4_index|
            device_value = HEADER_VALUE_4_DEVICE_INDEXES[value_4_index].sum { |device_index| packet_lengths[device_index] }
            device_value *= HEADER_VALUE_4_DEVICE_MULTIPLIERS[value_4_index]

            user_value = HEADER_VALUE_4_USER_INDEXES[value_4_index].sum { |device_index| packet_lengths[device_index] }
            user_value *= HEADER_VALUE_4_USER_MULTIPLIERS[value_4_index]

            value = device_value + user_value
            value += HEADER_VALUE_4_BASES[value_4_index]
            value += HEADER_VALUE_4_PHRASE * phrases.count
            value += HEADER_VALUE_4_DEVICE_BASE if device_nickname.any?

            value
          end
        end

        def header_values_5
          phrases.each_index.flat_map do |phrase_index|
            value = HEADER_VALUE_5_BASE

            if device_nickname.any?
              device_value = HEADER_VALUE_5_DEVICE_INDEXES.sum { |device_index| packet_lengths[device_index] }
              device_value *= HEADER_VALUE_5_DEVICE_MULTIPLIER
              device_value += HEADER_VALUE_5_DEVICE_BASE

              value += device_value
            end

            if user_nickname.any?
              user_value = HEADER_VALUE_5_USER_INDEXES.sum { |device_index| packet_lengths[device_index] }
              user_value *= HEADER_VALUE_5_USER_MULTIPLIER
              user_value += HEADER_VALUE_5_USER_BASE

              value += user_value
            end

            value += HEADER_VALUE_5_PHRASE * phrases.count
            value += HEADER_VALUE_5_PHRASE_PACKET * phrases.first(phrase_index).sum { |phrase| 1 + phrase.length / 4 }

            value
          end
        end

        def nickname_bytes
          four_byte_format_for(nicknames_with_suffixes)
        end

        def packet_lengths
          nicknames_with_suffixes.map { |nickname| 1 + nickname.length / 4 }
        end

        def nickname_format
          format = [device_nickname] * 2
          format += [user_nickname] * 9
          format += [device_nickname] * 4 if device_nickname.any?

          format
        end

        def nicknames_with_suffixes
          nickname_format.each_with_index.map do |nickname, nickname_index|
            nickname + NICKNAME_SUFFIXES[nickname_index]
          end
        end

        def formatted_phrases
          return [] if phrases.empty?

          four_byte_format_for(phrases)
        end
      end
    end
  end
end
