# frozen_string_literal: true

require "timex_datalink_client/helpers/char_encoders"
require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Protocol9
    class Timer
      include Helpers::CharEncoders
      prepend Helpers::CrcPacketsWrapper

      CPACKET_TIMER = [0x43]

      ACTION_AT_END_MAP = {
        stop_timer: 0,
        repeat_timer: 1,
        start_chrono: 2
      }.freeze

      attr_accessor :number, :label, :time, :action_at_end

      # Create a Timer instance.
      #
      # @param number [Integer] Entry number for timer.
      # @param label [String] Label for timer.
      # @param time [Time] Time of timer.
      # @param action_at_end [:stop_timer, :repeat_timer, :start_chrono] Action at end of timer.
      # @return [Timer] Timer instance.
      def initialize(number:, label:, time:, action_at_end:)
        @number = number
        @label = label
        @time = time
        @action_at_end = action_at_end
      end

      # Compile packets for a timer.
      #
      # @return [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
      def packets
        [
          [
            CPACKET_TIMER,
            number,
            time.hour,
            time.min,
            time.sec,
            action_at_end_value,
            label_characters
          ].flatten
        ]
      end

      private

      def action_at_end_value
        ACTION_AT_END_MAP.fetch(action_at_end)
      end

      def label_characters
        chars_for(label, length: 8, pad: true)
      end
    end
  end
end
