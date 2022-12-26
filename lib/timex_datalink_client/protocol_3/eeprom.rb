# frozen_string_literal: true

require "active_model"

require "timex_datalink_client/helpers/cpacket_paginator"
require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Protocol3
    class Eeprom
      include ActiveModel::Validations
      include Helpers::CpacketPaginator
      prepend Helpers::CrcPacketsWrapper

      CPACKET_CLEAR = [0x93, 0x01]
      CPACKET_SECT = [0x90, 0x01]
      CPACKET_DATA = [0x91, 0x01]
      CPACKET_END = [0x92, 0x01]

      CPACKET_DATA_LENGTH = 32
      START_ADDRESS = 0x0236
      APPOINTMENT_NO_NOTIFICATION = 0xff
      APPOINTMENT_NOTIFICATION_VALID_MINUTES = (0..30).step(5)

      attr_accessor :appointments, :anniversaries, :phone_numbers, :lists, :appointment_notification_minutes

      validates :appointment_notification_minutes, inclusion: {
        in: APPOINTMENT_NOTIFICATION_VALID_MINUTES,
        allow_nil: true,
        message: "value %{value} is invalid!  Valid appointment notification minutes values are" \
          " #{APPOINTMENT_NOTIFICATION_VALID_MINUTES.to_a} or nil."
      }

      # Create an Eeprom instance.
      #
      # @param appointments [Array<Appointment>] Appointments to be added to EEPROM data.
      # @param anniversaries [Array<Anniversary>] Anniversaries to be added to EEPROM data.
      # @param phone_numbers [Array<PhoneNumber>] Phone numbers to be added to EEPROM data.
      # @param lists [Array<List>] Lists to be added to EEPROM data.
      # @param appointment_notification_minutes [Integer, nil] Appointment notification in minutes.
      # @return [Eeprom] Eeprom instance.
      def initialize(
        appointments: [], anniversaries: [], phone_numbers: [], lists: [], appointment_notification_minutes: nil
      )
        @appointments = appointments
        @anniversaries = anniversaries
        @phone_numbers = phone_numbers
        @lists = lists
        @appointment_notification_minutes = appointment_notification_minutes
      end

      # Compile packets for EEPROM data.
      #
      # @raise [ActiveModel::ValidationError] One or more model values are invalid.
      # @return [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
      def packets
        validate!

        [CPACKET_CLEAR, header] + payloads + [CPACKET_END]
      end

      private

      def header
        [
          CPACKET_SECT,
          payloads.length,
          items_addresses,
          items_lengths,
          earliest_appointment_year,
          appointment_notification_minutes_value
        ].flatten
      end

      def payloads
        paginate_cpackets(header: CPACKET_DATA, length: CPACKET_DATA_LENGTH, cpackets: all_packets)
      end

      def all_items
        [appointments, lists, phone_numbers, anniversaries]
      end

      def all_packets
        all_items.flatten.map(&:packet).flatten
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

      def appointment_notification_minutes_value
        return APPOINTMENT_NO_NOTIFICATION unless appointment_notification_minutes

        appointment_notification_minutes / 5
      end
    end
  end
end
