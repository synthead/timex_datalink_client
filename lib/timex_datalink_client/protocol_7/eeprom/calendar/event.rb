# frozen_string_literal: true

require "active_model"

require "timex_datalink_client/helpers/lsb_msb_formatter"

class TimexDatalinkClient
  class Protocol7
    class Eeprom
      class Calendar
        class Event
          include ActiveModel::Validations
          include Helpers::LsbMsbFormatter

          FIVE_MINUTES_SECONDS = 300

          validates :time, comparison: {
            greater_than_or_equal_to: :device_time,
            message: "%{value} must be greater or equal to device time!"
          }

          attr_accessor :time, :phrase, :device_time

          # Create an Event instance.
          #
          # @param time [::Time] Time of event.
          # @param phrase [Array<Integer>] Phrase for event.
          # @raise [ActiveModel::ValidationError] One or more model values are invalid.
          # @return [Event] Event instance.
          def initialize(time:, phrase:)
            @time = time
            @phrase = phrase
          end

          def time_formatted(device_time)
            @device_time = device_time

            validate!

            device_time_midnight = Time.new(device_time.year, device_time.month, device_time.day)
            seconds = (time - device_time_midnight).to_i
            five_minutes = seconds / FIVE_MINUTES_SECONDS

            lsb_msb_format_for(five_minutes)
          end
        end
      end
    end
  end
end
