# frozen_string_literal: true

require "tzinfo"

require "spec_helper"

describe TimexDatalinkClient::Protocol3::Time do
  let(:zone) { 1 }
  let(:is_24h) { false }
  let(:date_format) { "%_m-%d-%y" }
  let(:tzinfo) { TZInfo::Timezone.get("US/Pacific") }
  let(:time) { tzinfo.local_time(2015, 10, 21, 19, 28, 32) }
  let(:name) { nil }

  let(:time_instance) do
    described_class.new(
      zone:,
      is_24h:,
      date_format:,
      time:,
      name:
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

    context "when zone is 0" do
      let(:zone) { 0 }

      it do
        expect { packets }.to raise_error(
          ActiveModel::ValidationError,
          "Validation failed: Zone 0 is invalid!  Valid zones are 1..2."
        )
      end
    end

    context "when zone is 3" do
      let(:zone) { 3 }

      it do
        expect { packets }.to raise_error(
          ActiveModel::ValidationError,
          "Validation failed: Zone 3 is invalid!  Valid zones are 1..2."
        )
      end
    end

    context "when is_24h is true" do
      let(:is_24h) { true }

      it_behaves_like "CRC-wrapped packets", [
        [0x32, 0x01, 0x20, 0x13, 0x1c, 0x0a, 0x15, 0x0f, 0x19, 0x0d, 0x1d, 0x02, 0x02, 0x00]
      ]
    end

    context "when date_format is \"%_d-%m-%y\"" do
      let(:date_format) { "%_d-%m-%y" }

      it_behaves_like "CRC-wrapped packets", [
        [0x32, 0x01, 0x20, 0x13, 0x1c, 0x0a, 0x15, 0x0f, 0x19, 0x0d, 0x1d, 0x02, 0x01, 0x01]
      ]
    end

    context "when date_format is \"%y-%m-%d\"" do
      let(:date_format) { "%y-%m-%d" }

      it_behaves_like "CRC-wrapped packets", [
        [0x32, 0x01, 0x20, 0x13, 0x1c, 0x0a, 0x15, 0x0f, 0x19, 0x0d, 0x1d, 0x02, 0x01, 0x02]
      ]
    end

    context "when date_format is \"%_m.%d.%y\"" do
      let(:date_format) { "%_m.%d.%y" }

      it_behaves_like "CRC-wrapped packets", [
        [0x32, 0x01, 0x20, 0x13, 0x1c, 0x0a, 0x15, 0x0f, 0x19, 0x0d, 0x1d, 0x02, 0x01, 0x04]
      ]
    end

    context "when date_format is \"%_d.%m.%y\"" do
      let(:date_format) { "%_d.%m.%y" }

      it_behaves_like "CRC-wrapped packets", [
        [0x32, 0x01, 0x20, 0x13, 0x1c, 0x0a, 0x15, 0x0f, 0x19, 0x0d, 0x1d, 0x02, 0x01, 0x05]
      ]
    end

    context "when date_format is \"%y.%m.%d\"" do
      let(:date_format) { "%y.%m.%d" }

      it_behaves_like "CRC-wrapped packets", [
        [0x32, 0x01, 0x20, 0x13, 0x1c, 0x0a, 0x15, 0x0f, 0x19, 0x0d, 0x1d, 0x02, 0x01, 0x06]
      ]
    end

    context "when date_format is \"%y\"" do
      let(:date_format) { "%y" }

      it do
        expect { packets }.to raise_error(
          ActiveModel::ValidationError,
          "Validation failed: Date format %y is invalid!  Valid date formats are [\"%_m-%d-%y\", \"%_d-%m-%y\"," \
          " \"%y-%m-%d\", \"%_m.%d.%y\", \"%_d.%m.%y\", \"%y.%m.%d\"]."
        )
      end
    end

    context "when time is 1997-09-19 19:36:55 NZDT" do
      let(:tzinfo) { TZInfo::Timezone.get("Pacific/Auckland") }
      let(:time) { tzinfo.local_time(1997, 9, 19, 19, 36, 55) }

      it_behaves_like "CRC-wrapped packets", [
        [0x32, 0x01, 0x37, 0x13, 0x24, 0x09, 0x13, 0x61, 0x17, 0x23, 0x1c, 0x04, 0x01, 0x00]
      ]
    end

    context "when time does not contain a time zone" do
      let(:time) { Time.new(1997, 9, 19, 19, 36, 55, 0) }

      it_behaves_like "CRC-wrapped packets", [
        [0x32, 0x01, 0x37, 0x13, 0x24, 0x09, 0x13, 0x61, 0x1d, 0x23, 0x01, 0x04, 0x01, 0x00]
      ]

      context "when zone is 2" do
        let(:zone) { 2 }

        it_behaves_like "CRC-wrapped packets", [
          [0x32, 0x02, 0x37, 0x13, 0x24, 0x09, 0x13, 0x61, 0x1d, 0x23, 0x02, 0x04, 0x01, 0x00]
        ]
      end
    end

    context "when name is \"1\"" do
      let(:name) { "1" }

      it_behaves_like "CRC-wrapped packets", [
        [0x32, 0x01, 0x20, 0x13, 0x1c, 0x0a, 0x15, 0x0f, 0x01, 0x24, 0x24, 0x02, 0x01, 0x00]
      ]
    end

    context "when name is \"<>[\"" do
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
