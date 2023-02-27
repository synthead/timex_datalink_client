# frozen_string_literal: true

require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Protocol6
    class PagerOptions
      include ActiveModel::Validations
      prepend Helpers::CrcPacketsWrapper

      CPACKET_PAGER = 0x73
      ALERT_SOUND_SILENT = 6

      validates :on_hour, inclusion: {
        in: 0..23,
        message: "%{value} is invalid!  Valid on hour values are 0..23."
      }

      validates :on_minute, inclusion: {
        in: 0..59,
        message: "%{value} is invalid!  Valid on minute values are 0..59."
      }

      validates :off_hour, inclusion: {
        in: 0..23,
        message: "%{value} is invalid!  Valid off hour values are 0..23."
      }

      validates :off_minute, inclusion: {
        in: 0..59,
        message: "%{value} is invalid!  Valid off minute values are 0..59."
      }

      validates :alert_sound, inclusion: {
        in: 0..5,
        allow_nil: true,
        message: "%{value} is invalid!  Valid alert sound values are 0..5 and nil."
      }

      attr_accessor :auto_on_off, :on_hour, :on_minute, :off_hour, :off_minute, :alert_sound

      # Create a PagerOptions instance.
      #
      # @param auto_on_off [Boolean] Toggle turning pager on and off every day.
      # @param on_hour [Integer] Hour to turn pager on at.
      # @param on_minute [Integer] Minute to turn pager on at.
      # @param off_hour [Integer] Hour to turn pager off at.
      # @param off_minute [Integer] Minute to turn pager off at.
      # @param alert_sound [Integer, nil] Pager alert sound (0 to 5 or nil for silent).
      # @return [PagerOptions] PagerOptions instance.
      def initialize(auto_on_off: false, on_hour: 0, on_minute: 0, off_hour: 0, off_minute: 0, alert_sound: 0)
        @auto_on_off = auto_on_off
        @on_hour = on_hour
        @on_minute = on_minute
        @off_hour = off_hour
        @off_minute = off_minute
        @alert_sound = alert_sound
      end

      # Compile packets for pager options.
      #
      # @raise [ActiveModel::ValidationError] One or more model values are invalid.
      # @return [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
      def packets
        validate!

        [
          [
            CPACKET_PAGER,
            auto_on_off_formatted,
            on_hour,
            on_minute,
            off_hour,
            off_minute,
            alert_sound_formatted
          ]
        ]
      end

      def auto_on_off_formatted
        auto_on_off ? 1 : 0
      end

      def alert_sound_formatted
        alert_sound || ALERT_SOUND_SILENT
      end
    end
  end
end
