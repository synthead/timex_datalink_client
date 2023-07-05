# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol1::TimeName do
  let(:zone) { 1 }
  let(:name) { "CST" }

  let(:time_instance) do
    described_class.new(
      zone:,
      name:
    )
  end

  describe "#packets", :crc do
    subject(:packets) { time_instance.packets }

    it_behaves_like "CRC-wrapped packets", [
      [0x31, 0x01, 0x0c, 0x1c, 0x1d]
    ]

    context "when zone is 2" do
      let(:zone) { 2 }

      it_behaves_like "CRC-wrapped packets", [
        [0x31, 0x02, 0x0c, 0x1c, 0x1d]
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

    context "when name is \"1\"" do
      let(:name) { "1" }

      it_behaves_like "CRC-wrapped packets", [
        [0x31, 0x01, 0x01, 0x24, 0x24]
      ]
    end

    context "when name is \"<>[\"" do
      let(:name) { "<>[" }

      it_behaves_like "CRC-wrapped packets", [
        [0x31, 0x01, 0x3c, 0x3d, 0x3e]
      ]
    end

    context "when name is \"Longer than 3 Characters\"" do
      let(:name) { "Longer than 3 Characters" }

      it_behaves_like "CRC-wrapped packets", [
        [0x31, 0x01, 0x15, 0x18, 0x17]
      ]
    end

    context "when name is nil" do
      let(:name) { nil }

      it_behaves_like "CRC-wrapped packets", [
        [0x31, 0x01, 0x1d, 0x23, 0x01]
      ]

      context "when zone is 2" do
        let(:zone) { 2 }

        it_behaves_like "CRC-wrapped packets", [
          [0x31, 0x02, 0x1d, 0x23, 0x02]
        ]
      end
    end
  end
end
