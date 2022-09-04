# frozen_string_literal: true

class TimexDatalinkClient
  class Eeprom
    prepend Crc

    START_ADDRESS = 0x0236
    ITEMS_PER_PACKET = 32

    CLEAR_COMMAND = [0x93, 0x01]
    HEADER_COMMAND = [0x90, 0x01]
    PAYLOAD_COMMAND = [0x91, 0x01]
    END_COMMAND = [0x92, 0x01]

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
      [CLEAR_COMMAND, header] + payloads + [END_COMMAND]
    end

    private

    def header
      [
        HEADER_COMMAND,
        packet_count,
        items_addresses,
        items_lengths,
        earliest_appointment_year,
        appointment_notification
      ].flatten
    end

    def payloads
      all_packets = all_items.flatten.map(&:packet).flatten
      paginated_packets = all_packets.each_slice(ITEMS_PER_PACKET)

      paginated_packets.each.with_index(1).map do |paginated_packet, index|
        PAYLOAD_COMMAND + [index] + paginated_packet
      end
    end

    def all_items
      [appointments, lists, phone_numbers, anniversaries]
    end

    def packet_count
      item_packets = all_items.flatten.sum { |item| item.packet.length }
      item_packets.fdiv(ITEMS_PER_PACKET).ceil
    end

    def items_addresses
      address = START_ADDRESS

      all_items.each_with_object([]) do |items, addresses|
        addresses.concat(address.divmod(256))

        address += items.sum { |item| item.packet.length }
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
