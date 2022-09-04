# frozen_string_literal: true

class TimexDatalinkClient
  class Alarm
    prepend Crc
    include CharEncoder

    CPACKET_ALARM = [0x50]
    MESSAGE_LENGTH = 8

    attr_accessor :number, :audible, :time, :message

    def initialize(number:, audible:, time:, message:)
      @number = number
      @audible = audible
      @time = time
      @message = message
    end

    def packets
      [
        [
          CPACKET_ALARM,
          number,
          time.hour,
          time.min,
          0,
          0,
          message_characters,
          audible
        ].flatten
      ]
    end

    private

    def message_characters
      message_padded = message.ljust(MESSAGE_LENGTH)

      chars_for(message_padded)
    end
  end
end
