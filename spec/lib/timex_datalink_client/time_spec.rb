# frozen_string_literal: true

require "tzinfo"

require "spec_helper"

describe TimexDatalinkClient::Time do
  let(:zone) { 1 }
  let(:is_24h) { false }
  let(:date_format) { 0 }
  let(:tzinfo) { TZInfo::Timezone.get("US/Pacific") }
  let(:time) { tzinfo.local_time(2015, 10, 21, 19, 28, 32) }
  let(:name) { nil }

  let(:time_instance) do
    described_class.new(
      zone: zone,
      is_24h: is_24h,
      date_format: date_format,
      time: time,
      name: name
    )
  end

  describe "#packets", :crc do
    subject(:packets) { time_instance.packets }

    it_behaves_like "CRC-wrapped packets", [
      [0x32, 0x01, 0x20, 0x13, 0x1c, 0x0a, 0x15, 0x0f, 0x19, 0x0d, 0x1d, 0x02, 0x01, 0x00]
    ]

    context "when zone is 2" do
      let(:zone) { 2 }

      it_behaves_like "CRC-wrapped packets", [
        [0x32, 0x02, 0x20, 0x13, 0x1c, 0x0a, 0x15, 0x0f, 0x19, 0x0d, 0x1d, 0x02, 0x01, 0x00]
      ]
    end

    context "when is_24h is true" do
      let(:is_24h) { true }

      it_behaves_like "CRC-wrapped packets", [
        [0x32, 0x01, 0x20, 0x13, 0x1c, 0x0a, 0x15, 0x0f, 0x19, 0x0d, 0x1d, 0x02, 0x02, 0x00]
      ]
    end

    context "when date_format is 4" do
      let(:date_format) { 4 }

      it_behaves_like "CRC-wrapped packets", [
        [0x32, 0x01, 0x20, 0x13, 0x1c, 0x0a, 0x15, 0x0f, 0x19, 0x0d, 0x1d, 0x02, 0x01, 0x04]
      ]
    end

    context "when time is 2015-10-21 19:28:32 NZDT" do
      let(:tzinfo) { TZInfo::Timezone.get("Pacific/Auckland") }
      let(:time) { tzinfo.local_time(1997, 9, 19, 19, 36, 55) }

      it_behaves_like "CRC-wrapped packets", [
        [0x32, 0x01, 0x37, 0x13, 0x24, 0x09, 0x13, 0x61, 0x17, 0x23, 0x1c, 0x04, 0x01, 0x00]
      ]
    end

    context "when name is \"1\"" do
      let(:name) { "1" }

      it_behaves_like "CRC-wrapped packets", [
        [0x32, 0x01, 0x20, 0x13, 0x1c, 0x0a, 0x15, 0x0f, 0x01, 0x24, 0x24, 0x02, 0x01, 0x00]
      ]
    end

    context "when name is \"<>[" do
      let(:name) { "<>[" }

      it_behaves_like "CRC-wrapped packets", [
        [0x32, 0x01, 0x20, 0x13, 0x1c, 0x0a, 0x15, 0x0f, 0x3c, 0x3d, 0x3e, 0x02, 0x01, 0x00]
      ]
    end

    context "when name is \"Longer than 3 Characters\"" do
      let(:name) { "Longer than 3 Characters" }

      it_behaves_like "CRC-wrapped packets", [
        [0x32, 0x01, 0x20, 0x13, 0x1c, 0x0a, 0x15, 0x0f, 0x15, 0x18, 0x17, 0x02, 0x01, 0x00]
      ]
    end
  end
end
