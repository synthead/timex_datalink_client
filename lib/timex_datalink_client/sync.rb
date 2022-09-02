# frozen_string_literal: true

class TimexDatalinkClient
  module Sync
    def sync(sync_length: nil)
      Sync.write(serial, sync_length: sync_length)
    end

    class Sync
      SYNC_BYTE = "U"
      SYNC_LENGTH = 300

      def self.write(serial, sync_length: nil)
        sync_length ||= SYNC_LENGTH

        sync_length.times do
          serial.write(SYNC_BYTE)
        end
      end
    end
  end
end
