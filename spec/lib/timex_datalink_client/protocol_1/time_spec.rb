# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol1::Time do
  let(:zone) { 1 }
  let(:is_24h) { false }
  let(:time) { Time.new(2015, 10, 21, 19, 28, 32) }

  let(:time_instance) do
    described_class.new(
      zone: zone,
      is_24h: is_24h,
      time: time
    )
  end

  describe "#packets", :crc do
    subject(:packets) { time_instance.packets }

    it_behaves_like "CRC-wrapped packets", [
      [0x30, 0x01, 0x13, 0x1c, 0x0a, 0x15, 0x0f, 0x02, 0x20, 0x01]
    ]

    context "when zone is 2" do
      let(:zone) { 2 }

      it_behaves_like "CRC-wrapped packets", [
        [0x30, 0x02, 0x13, 0x1c, 0x0a, 0x15, 0x0f, 0x02, 0x20, 0x01]
      ]
    end

    context "when is_24h is true" do
      let(:is_24h) { true }

      it_behaves_like "CRC-wrapped packets", [
        [0x30, 0x01, 0x13, 0x1c, 0x0a, 0x15, 0x0f, 0x02, 0x20, 0x02]
      ]
    end

    context "when time is 2015-10-21 19:28:32" do
      let(:time) { Time.new(1997, 9, 19, 19, 36, 55) }

      it_behaves_like "CRC-wrapped packets", [
        [0x30, 0x01, 0x13, 0x24, 0x09, 0x13, 0x61, 0x04, 0x37, 0x01]
      ]
    end
  end
end
