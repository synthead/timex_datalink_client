# frozen_string_literal: true

require "active_model"

require "timex_datalink_client/helpers/char_encoders"
require "timex_datalink_client/helpers/length_packet_wrapper"

class TimexDatalinkClient
  class Protocol3
    class Eeprom
      class List
        include ActiveModel::Validations
        include Helpers::CharEncoders
        prepend Helpers::LengthPacketWrapper

        attr_accessor :list_entry, :priority

        validates :priority, inclusion: {
          in: 1..5,
          allow_nil: true,
          message: "%{value} is invalid!  Valid priorities are 1..5 or nil."
        }

        # Create a List instance.
        #
        # @param list_entry [String] List entry text.
        # @param priority [Integer, nil] List priority.
        # @return [List] List instance.
        def initialize(list_entry:, priority:)
          @list_entry = list_entry
          @priority = priority
        end

        # Compile a packet for a list.
        #
        # @raise [ActiveModel::ValidationError] One or more model values are invalid.
        # @return [Array<Integer>] Array of integers that represent bytes.
        def packet
          validate!

          [
            priority_value,
            list_entry_characters
          ].flatten
        end

        private

        def list_entry_characters
          eeprom_chars_for(list_entry)
        end

        def priority_value
          priority.nil? ? 0 : priority
        end
      end
    end
  end
end
