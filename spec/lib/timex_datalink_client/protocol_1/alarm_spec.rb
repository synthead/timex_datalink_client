# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol1::Alarm do
  let(:number) { 1 }
  let(:audible) { false }
  let(:time) { Time.new(1994) }
  let(:message) { "Alarm 1" }
  let(:month) { nil }
  let(:day) { nil }

  let(:alarm) do
    described_class.new(
      number: number,
      audible: audible,
      time: time,
      message: message,
      month: month,
      day: day
    )
  end

  describe "#packets", :crc do
    subject(:packets) { alarm.packets }

    it_behaves_like "CRC-wrapped packets", [
      [0x50, 0x01, 0x00, 0x00, 0x00, 0x00, 0x0a, 0x15, 0x0a, 0x1b, 0x16, 0x24, 0x01, 0x24, 0x00],
      [0x70, 0x00, 0x62, 0x00]
    ]

    context "when number is 2" do
      let(:number) { 2 }

      it_behaves_like "CRC-wrapped packets", [
        [0x50, 0x02, 0x00, 0x00, 0x00, 0x00, 0x0a, 0x15, 0x0a, 0x1b, 0x16, 0x24, 0x01, 0x24, 0x00],
        [0x70, 0x00, 0x63, 0x00]
      ]
    end

    context "when number is 0" do
      let(:number) { 0 }

      it do
        expect { packets }.to raise_error(
          ActiveModel::ValidationError,
          "Validation failed: Number value 0 is invalid!  Valid number values are 1..5."
        )
      end
    end

    context "when number is 6" do
      let(:number) { 6 }

      it do
        expect { packets }.to raise_error(
          ActiveModel::ValidationError,
          "Validation failed: Number value 6 is invalid!  Valid number values are 1..5."
        )
      end
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
        [0x50, 0x01, 0x10, 0x23, 0x00, 0x00, 0x0a, 0x15, 0x0a, 0x1b, 0x16, 0x24, 0x01, 0x24, 0x00],
        [0x70, 0x00, 0x62, 0x00]
      ]
    end

    context "when message is \"Wake Up with More than 8 Characters\"" do
      let(:message) { "Wake Up with More than 8 Characters" }

      it_behaves_like "CRC-wrapped packets", [
        [0x50, 0x01, 0x00, 0x00, 0x00, 0x00, 0x20, 0x0a, 0x14, 0x0e, 0x24, 0x1e, 0x19, 0x24, 0x00],
        [0x70, 0x00, 0x62, 0x00]
      ]
    end

    context "when message is \";@_|<>[]\"" do
      let(:message) { ";@_|<>[]" }

      it_behaves_like "CRC-wrapped packets", [
        [0x50, 0x01, 0x00, 0x00, 0x00, 0x00, 0x36, 0x38, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f, 0x00],
        [0x70, 0x00, 0x62, 0x00]
      ]
    end

    context "when message is \"~with~invalid~characters\"" do
      let(:message) { "~with~invalid~characters" }

      it_behaves_like "CRC-wrapped packets", [
        [0x50, 0x01, 0x00, 0x00, 0x00, 0x00, 0x24, 0x20, 0x12, 0x1d, 0x11, 0x24, 0x12, 0x17, 0x00],
        [0x70, 0x00, 0x62, 0x00]
      ]
    end

    context "when month is 2" do
      let(:month) { 2 }

      it_behaves_like "CRC-wrapped packets", [
        [0x50, 0x01, 0x00, 0x00, 0x02, 0x00, 0x0a, 0x15, 0x0a, 0x1b, 0x16, 0x24, 0x01, 0x24, 0x00],
        [0x70, 0x00, 0x62, 0x00]
      ]

      context "when day is 35" do
        let(:day) { 35 }

        it do
          expect { packets }.to raise_error(
            ActiveModel::ValidationError,
            "Validation failed: Day 35 is invalid for month 2!  Valid days are 1..29 and nil when month is 2."
          )
        end
      end
    end

    context "when month is 0" do
      let(:month) { 0 }

      it do
        expect { packets }.to raise_error(
          ActiveModel::ValidationError,
          "Validation failed: Month 0 is invalid!  Valid months are 1..12 and nil."
        )
      end
    end

    context "when month is 13" do
      let(:month) { 13 }

      it do
        expect { packets }.to raise_error(
          ActiveModel::ValidationError,
          "Validation failed: Month 13 is invalid!  Valid months are 1..12 and nil."
        )
      end
    end

    context "when day is 25" do
      let(:day) { 25 }

      it_behaves_like "CRC-wrapped packets", [
        [0x50, 0x01, 0x00, 0x00, 0x00, 0x19, 0x0a, 0x15, 0x0a, 0x1b, 0x16, 0x24, 0x01, 0x24, 0x00],
        [0x70, 0x00, 0x62, 0x00]
      ]
    end

    context "when day is 0" do
      let(:day) { 0 }

      it do
        expect { packets }.to raise_error(
          ActiveModel::ValidationError,
          "Validation failed: Day 0 is invalid!  Valid days are 1..31 and nil."
        )
      end
    end

    context "when day is 32" do
      let(:day) { 32 }

      it do
        expect { packets }.to raise_error(
          ActiveModel::ValidationError,
          "Validation failed: Day 32 is invalid!  Valid days are 1..31 and nil."
        )
      end
    end

  end
end
