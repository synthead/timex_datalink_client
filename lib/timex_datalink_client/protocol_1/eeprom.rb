# frozen_string_literal: true

require "timex_datalink_client/helpers/cpacket_paginator"
require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Protocol1
    class Eeprom
      include Helpers::CpacketPaginator
      prepend Helpers::CrcPacketsWrapper

      CPACKET_SECT = [0x60]
      CPACKET_DATA = [0x61]
      CPACKET_END = [0x62]

      CPACKET_DATA_LENGTH = 27
      START_INDEX = 14
      APPOINTMENT_NO_NOTIFICATION = 0xff

      attr_accessor :appointments, :anniversaries, :phone_numbers, :lists, :appointment_notification

      # Create an Eeprom instance.
      #
      # @param appointments [Array<Appointment>] Appointments to be added to EEPROM data.
      # @param anniversaries [Array<Anniversary>] Anniversaries to be added to EEPROM data.
      # @param phone_numbers [Array<PhoneNumber>] Phone numbers to be added to EEPROM data.
      # @param lists [Array<List>] Lists to be added to EEPROM data.
      # @param appointment_notification [Integer] Appointment notification (intervals of 15 minutes, 255 for no
      #   notification)
      # @return [Eeprom] Eeprom instance.
      def initialize(appointments: [], anniversaries: [], phone_numbers: [], lists: [], appointment_notification: APPOINTMENT_NO_NOTIFICATION)
        @appointments = appointments
        @anniversaries = anniversaries
        @phone_numbers = phone_numbers
        @lists = lists
        @appointment_notification = appointment_notification
      end

      # Compile packets for EEPROM data.
      #
      # @return [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
      def packets
        [header] + payloads + [CPACKET_END]
      end

      private

      def header
        [
          CPACKET_SECT,
          payloads.length
        ].flatten
      end

      def payload
        [
          items_indexes,
          items_lengths,
          earliest_appointment_year,
          appointment_notification,
          all_packets
        ].flatten
      end

      def payloads
        paginate_cpackets(header: CPACKET_DATA, length: CPACKET_DATA_LENGTH, cpackets: payload)
      end

      def all_items
        [appointments, lists, phone_numbers, anniversaries]
      end

      def all_packets
        all_items.flatten.map(&:packet).flatten
      end

      def items_indexes
        index = START_INDEX

        all_items.each_with_object([]) do |items, indexes|
          indexes.concat(index.divmod(256))

          index += items.sum { |item| item.packet.length }
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
end
