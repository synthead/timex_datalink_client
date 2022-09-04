# frozen_string_literal: true

class TimexDatalinkClient
  class Eeprom
    prepend Crc
    # include CharEncoder

    START_ADDRESS = 0x0236
    ITEMS_PER_PACKET = 32

    CLEAR_COMMAND = "\x93\x01"
    HEADER_COMMAND = "\x90\x01"
    PAYLOAD_COMMAND = "\x91\x01"
    END_COMMAND = "\x92\x01"

    APPOINTMENT_NO_NOTIFICATION = 0xff

    attr_accessor :appointments, :anniversaries, :phone_numbers, :lists, :appointment_notification

    def initialize(appointments: [], anniversaries: [], phone_numbers: [], lists: [], appointment_notification: APPOINTMENT_NO_NOTIFICATION)
      @appointments = appointments
      @anniversaries = anniversaries
      @phone_numbers = phone_numbers
      @lists = lists
      @appointment_notification = appointment_notification
    end

    def packets
      [
        CLEAR_COMMAND,
        header,
        payload,
        END_COMMAND
      ].flatten
    end

    private

    def header
      HEADER_COMMAND + header_array.pack("C*").force_encoding("UTF-8")
    end

    def header_array
      [
        packet_count,
        items_addresses,
        items_lengths,
        earliest_appointment_year,
        appointment_notification
      ].flatten
    end

    def payload
      packets = all_items.flatten.map(&:packet).join
      paginated_bytes = packets.bytes.each_slice(ITEMS_PER_PACKET)

      paginated_bytes.each.with_index(1).map do |paginated_byte, index|
        PAYLOAD_COMMAND + index.chr + paginated_byte.pack("C*").force_encoding("UTF-8")
      end
    end

    def all_items
      [appointments, lists, phone_numbers, anniversaries]
    end

    def packet_count
      item_packets = all_items.flatten.sum { |item| item.packet.bytesize }
      item_packets.fdiv(ITEMS_PER_PACKET).ceil
    end

    def items_addresses
      address = START_ADDRESS

      all_items.each_with_object([]) do |items, addresses|
        addresses.concat(address.divmod(256))

        address += items.sum { |item| item.packet.bytesize }
      end
    end

    def items_lengths
      all_items.map(&:length)
    end

    def earliest_appointment_year
      earliest_appointment = appointments.min_by(&:time)

      return 0 unless earliest_appointment

      earliest_appointment.time.year % 100
    end
  end
end
