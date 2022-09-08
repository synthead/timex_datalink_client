# frozen_string_literal: true

require "timex_datalink_client/helpers/cpacket_paginator"
require "timex_datalink_client/helpers/crc_packets_wrapper"

class TimexDatalinkClient
  class Eeprom
    include Helpers::CpacketPaginator
    prepend Helpers::CrcPacketsWrapper

    CPACKET_CLEAR = [0x93, 0x01]
    CPACKET_SECT = [0x90, 0x01]
    CPACKET_DATA = [0x91, 0x01]
    CPACKET_END = [0x92, 0x01]

    START_ADDRESS = 0x0236
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
    # @return [void]
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
        appointment_notification
      ].flatten
    end

    def payloads
      paginate_cpackets(header: CPACKET_DATA, cpackets: all_packets)
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
  end
end
