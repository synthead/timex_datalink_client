# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Alarm do
  let(:number) { 1 }
  let(:audible) { false }
  let(:time) { Time.new(1994) }
  let(:message) { "alarm 1" }

  let(:alarm) do
    described_class.new(
      number: number,
      audible: audible,
      time: time,
      message: message
    )
  end

  describe "#packets", :crc do
    subject(:packets) { alarm.packets }

    it_behaves_like "CRC-wrapped packets", [
      [0x50, 0x01, 0x00, 0x00, 0x00, 0x00, 0x0a, 0x15, 0x0a, 0x1b, 0x16, 0x24, 0x01, 0x24, 0x00]
    ]

    context "when number is 2" do
      let(:number) { 2 }

      it_behaves_like "CRC-wrapped packets", [
        [0x50, 0x02, 0x00, 0x00, 0x00, 0x00, 0x0a, 0x15, 0x0a, 0x1b, 0x16, 0x24, 0x01, 0x24, 0x00]
      ]
    end

    context "when audible is true" do
      let(:audible) { true }

      it_behaves_like "CRC-wrapped packets", [
        [0x50, 0x01, 0x00, 0x00, 0x00, 0x00, 0x0a, 0x15, 0x0a, 0x1b, 0x16, 0x24, 0x01, 0x24, 0x01]
      ]
    end

    context "when time is 16:35" do
      let(:time) { Time.new(1994, 1, 1, 16, 35) }

      it_behaves_like "CRC-wrapped packets", [
        [0x50, 0x01, 0x10, 0x23, 0x00, 0x00, 0x0a, 0x15, 0x0a, 0x1b, 0x16, 0x24, 0x01, 0x24, 0x00]
      ]
    end

    context "when message is \"wake up with more than 8 characters\"" do
      let(:message) { "wake up with more than 8 characters" }

      it_behaves_like "CRC-wrapped packets", [
        [0x50, 0x01, 0x00, 0x00, 0x00, 0x00, 0x20, 0x0a, 0x14, 0x0e, 0x24, 0x1e, 0x19, 0x24, 0x00]
      ]
    end
  end
end
