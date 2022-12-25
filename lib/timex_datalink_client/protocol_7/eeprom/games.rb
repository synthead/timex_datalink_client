# frozen_string_literal: true

require "timex_datalink_client/helpers/four_byte_formatter"
require "timex_datalink_client/helpers/lsb_msb_formatter"

class TimexDatalinkClient
  class Protocol7
    class Eeprom
      class Games
        include Helpers::FourByteFormatter
        include Helpers::LsbMsbFormatter

        COUNTDOWN_TIMER_SECONDS_DEFAULT = 60

        COUNTDOWN_TIMER_SOUND_DEFAULT = 0x062
        MUSIC_TIME_KEEPER_SOUND_DEFAULT = 0x062

        PACKETS_TERMINATOR = 0x02

        attr_accessor :memory_game_enabled, :fortune_teller_enabled, :countdown_timer_enabled, :countdown_timer_seconds,
          :countdown_timer_sound, :mind_reader_enabled, :music_time_keeper_enabled, :music_time_keeper_sound,
          :morse_code_practice_enabled, :treasure_hunter_enabled, :rhythm_rhyme_buster_enabled, :stop_watch_enabled,
          :red_light_green_light_enabled

        # Create a Games instance.
        #
        # @param memory_game_enabled [Boolean] Toggle memory game.
        # @param fortune_teller_enabled [Boolean] Toggle fortune teller.
        # @param countdown_timer_enabled [Boolean] Toggle countdown timer.
        # @param countdown_timer_seconds [Integer] Duration for countdown timer in seconds.
        # @param countdown_timer_sound [Integer] Sound for countdown timer.
        # @param mind_reader_enabled [Boolean] Toggle mind reader.
        # @param music_time_keeper_enabled [Boolean] Toggle music time keeper.
        # @param music_time_keeper_sound [Integer] Sound for music time keeper.
        # @param morse_code_practice_enabled [Boolean] Toggle Morse code practice.
        # @param treasure_hunter_enabled [Boolean] Toggle treasure hunter.
        # @param rhythm_rhyme_buster_enabled [Boolean] Toggle rhythm & rhyme buster.
        # @param stop_watch_enabled [Boolean] Toggle stop watch.
        # @param red_light_green_light_enabled [Boolean] Toggle red light, green light.
        # @return [Games] Games instance.
        def initialize(
          memory_game_enabled: false,
          fortune_teller_enabled: false,
          countdown_timer_enabled: false,
          countdown_timer_seconds: COUNTDOWN_TIMER_SECONDS_DEFAULT,
          countdown_timer_sound: COUNTDOWN_TIMER_SOUND_DEFAULT,
          mind_reader_enabled: false,
          music_time_keeper_enabled: false,
          music_time_keeper_sound: MUSIC_TIME_KEEPER_SOUND_DEFAULT,
          morse_code_practice_enabled: false,
          treasure_hunter_enabled: false,
          rhythm_rhyme_buster_enabled: false,
          stop_watch_enabled: false,
          red_light_green_light_enabled: false
        )
          @memory_game_enabled = memory_game_enabled
          @fortune_teller_enabled = fortune_teller_enabled
          @countdown_timer_enabled = countdown_timer_enabled
          @countdown_timer_seconds = countdown_timer_seconds
          @countdown_timer_sound = countdown_timer_sound
          @mind_reader_enabled = mind_reader_enabled
          @music_time_keeper_enabled = music_time_keeper_enabled
          @music_time_keeper_sound = music_time_keeper_sound
          @morse_code_practice_enabled = morse_code_practice_enabled
          @treasure_hunter_enabled = treasure_hunter_enabled
          @rhythm_rhyme_buster_enabled = rhythm_rhyme_buster_enabled
          @stop_watch_enabled = stop_watch_enabled
          @red_light_green_light_enabled = red_light_green_light_enabled
        end

        # Compile data for games.
        #
        # @return [Array<Integer>] Compiled data for games.
        def packet
          [
            enabled_games,
            countdown_timer_time,
            sounds,
            PACKETS_TERMINATOR
          ].flatten
        end

        private

        def enabled_games
          bitmask = games.each_with_index.sum do |game, game_index|
            game ? 1 << game_index : 0
          end

          lsb_msb_format_for(bitmask)
        end

        def countdown_timer_time
          lsb_msb_format_for(countdown_timer_seconds * 10)
        end

        def sounds
          sounds_extra_packet = four_byte_format_for(
            [
              [music_time_keeper_sound],
              [countdown_timer_sound],
              []
            ]
          )

          sounds_extra_packet.first(10)
        end

        def games
          [
            memory_game_enabled,
            fortune_teller_enabled,
            countdown_timer_enabled,
            mind_reader_enabled,
            music_time_keeper_enabled,
            morse_code_practice_enabled,
            treasure_hunter_enabled,
            rhythm_rhyme_buster_enabled,
            stop_watch_enabled,
            red_light_green_light_enabled
          ]
        end
      end
    end
  end
end
