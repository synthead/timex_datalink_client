# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol6::Alarm do
  let(:number) { 1 }
  let(:status) { :disarmed }
  let(:time) { Time.new(0, 1, 1, 0, 0) }
  let(:message) { "Alarm 1" }
  let(:month) { nil }
  let(:day) { nil }

  let(:alarm) do
    described_class.new(
      number:,
      status:,
      time:,
      message:,
      month:,
      day:
    )
  end

  describe "#packets", :crc do
    subject(:packets) { alarm.packets }

    it_behaves_like "CRC-wrapped packets", [
      [
        0x51, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0b, 0x16, 0x0b, 0x1c, 0x17, 0x0a, 0x01, 0x0a, 0x0a, 0x0a, 0x0a,
        0x0a, 0x0a, 0x0a, 0x0a, 0x0a
      ]
    ]

    context "when number is 2" do
      let(:number) { 2 }

      it_behaves_like "CRC-wrapped packets", [
        [
          0x51, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0b, 0x16, 0x0b, 0x1c, 0x17, 0x0a, 0x01, 0x0a, 0x0a, 0x0a, 0x0a,
          0x0a, 0x0a, 0x0a, 0x0a, 0x0a
        ]
      ]
    end

    context "when number is 0" do
      let(:number) { 0 }

      it do
        expect { packets }.to raise_error(
          ActiveModel::ValidationError,
          "Validation failed: Number value 0 is invalid!  Valid number values are 1..8."
        )
      end
    end

    context "when number is 9" do
      let(:number) { 9 }

      it do
        expect { packets }.to raise_error(
          ActiveModel::ValidationError,
          "Validation failed: Number value 9 is invalid!  Valid number values are 1..8."
        )
      end
    end

    context "when status is :armed" do
      let(:status) { :armed }

      it_behaves_like "CRC-wrapped packets", [
        [
          0x51, 0x01, 0x00, 0x00, 0x00, 0x00, 0x01, 0x0b, 0x16, 0x0b, 0x1c, 0x17, 0x0a, 0x01, 0x0a, 0x0a, 0x0a, 0x0a,
          0x0a, 0x0a, 0x0a, 0x0a, 0x0a
        ]
      ]
    end

    context "when status is :unused" do
      let(:status) { :unused }

      it_behaves_like "CRC-wrapped packets", [
        [
          0x51, 0x01, 0x00, 0x00, 0x00, 0x00, 0x02, 0x0b, 0x16, 0x0b, 0x1c, 0x17, 0x0a, 0x01, 0x0a, 0x0a, 0x0a, 0x0a,
          0x0a, 0x0a, 0x0a, 0x0a, 0x0a
        ]
      ]
    end

    context "when status is :an_invalid_symbol" do
      let(:status) { :invalid_status }

      it do
        expect { packets }.to raise_error(
          ActiveModel::ValidationError,
          "Validation failed: Status invalid_status is invalid!  Valid date formats are [:disarmed, :armed, :unused]."
        )
      end
    end

    context "when time is 16:35" do
      let(:time) { Time.new(0, 1, 1, 16, 35) }

      it_behaves_like "CRC-wrapped packets", [
        [
          0x51, 0x01, 0x10, 0x23, 0x00, 0x00, 0x00, 0x0b, 0x16, 0x0b, 0x1c, 0x17, 0x0a, 0x01, 0x0a, 0x0a, 0x0a, 0x0a,
          0x0a, 0x0a, 0x0a, 0x0a, 0x0a
        ]
      ]
    end

    context "when message is \"Wake Up with More than 16 Characters\"" do
      let(:message) { "Wake Up with More than 16 Characters" }

      it_behaves_like "CRC-wrapped packets", [
        [
          0x51, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x21, 0x0b, 0x15, 0x0f, 0x0a, 0x1f, 0x1a, 0x0a, 0x21, 0x13, 0x1e,
          0x12, 0x0a, 0x17, 0x19, 0x1c
        ]
      ]
    end

    context "when message is \"()*+,-./:;<=>?@[\\\"" do
      let(:message) { "()*+,-./:;<=>?@[\\\"" }

      it_behaves_like "CRC-wrapped packets", [
        [
          0x51, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x2c, 0x2d, 0x2e, 0x2f, 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36,
          0x37, 0x38, 0x39, 0x3a, 0x3b
        ]
      ]
    end

    context "when message is \"¢with¢invalid¢characters\"" do
      let(:message) { "¢with¢invalid¢characters" }

      it_behaves_like "CRC-wrapped packets", [
        [
          0x51, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0a, 0x21, 0x13, 0x1e, 0x12, 0x0a, 0x13, 0x18, 0x20, 0x0b, 0x16,
          0x13, 0x0e, 0x0a, 0x0d, 0x12
        ]
      ]
    end

    context "when month is 2" do
      let(:month) { 2 }

      it_behaves_like "CRC-wrapped packets", [
        [
          0x51, 0x01, 0x00, 0x00, 0x02, 0x00, 0x00, 0x0b, 0x16, 0x0b, 0x1c, 0x17, 0x0a, 0x01, 0x0a, 0x0a, 0x0a, 0x0a,
          0x0a, 0x0a, 0x0a, 0x0a, 0x0a
        ]
      ]

      context "when day is 30" do
        let(:day) { 30 }

        it do
          expect { packets }.to raise_error(
            ActiveModel::ValidationError,
            "Validation failed: Day 30 is invalid for month 2!  Valid days are 1..29 and nil when month is 2."
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
        [
          0x51, 0x01, 0x00, 0x00, 0x00, 0x19, 0x00, 0x0b, 0x16, 0x0b, 0x1c, 0x17, 0x0a, 0x01, 0x0a, 0x0a, 0x0a, 0x0a,
          0x0a, 0x0a, 0x0a, 0x0a, 0x0a
        ]
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
