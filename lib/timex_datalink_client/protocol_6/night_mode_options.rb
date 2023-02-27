# frozen_string_literal: true

require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Protocol6
    class NightModeOptions
      include ActiveModel::Validations
      prepend Helpers::CrcPacketsWrapper

      CPACKET_NIGHT_MODE = 0x72

      validates :night_mode_deactivate_hours, inclusion: {
        in: 3..12,
        message: "%{value} is invalid!  Valid night mode deactivate hour values are 3..12."
      }

      validates :indiglo_timeout_seconds, inclusion: {
        in: 3..10,
        message: "%{value} is invalid!  Valid Indiglo timeout second values are 3..10."
      }

      attr_accessor :night_mode_deactivate_hours, :indiglo_timeout_seconds, :night_mode_on_notification

      # Create a NightModeOptions instance.
      #
      # @param night_mode_deactivate_hours [Integer] Automatically deactivate night mode after specified hours.
      # @param indiglo_timeout_seconds [Integer] Turn Indiglo light off after specified seconds after each button push.
      # @param night_mode_on_notification [Boolean] Toggle activating night mode on any pager or alarm event.
      # @return [NightModeOptions] NightModeOptions instance.
      def initialize(night_mode_deactivate_hours: 8, indiglo_timeout_seconds: 4, night_mode_on_notification: false)
        @night_mode_deactivate_hours = night_mode_deactivate_hours
        @indiglo_timeout_seconds = indiglo_timeout_seconds
        @night_mode_on_notification = night_mode_on_notification
      end

      # Compile packets for night mode options.
      #
      # @raise [ActiveModel::ValidationError] One or more model values are invalid.
      # @return [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
      def packets
        validate!

        [
          [
            CPACKET_NIGHT_MODE,
            night_mode_on_notification_formatted,
            night_mode_deactivate_hours,
            indiglo_timeout_seconds
          ]
        ]
      end

      def night_mode_on_notification_formatted
        night_mode_on_notification ? 1 : 0
      end
    end
  end
end
