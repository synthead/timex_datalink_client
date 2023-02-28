# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol6::NightModeOptions do
  let(:night_mode_deactivate_hours) { 8 }
  let(:indiglo_timeout_seconds) { 4 }
  let(:night_mode_on_notification) { false }

  let(:night_mode_options) do
    described_class.new(
      night_mode_deactivate_hours:,
      indiglo_timeout_seconds:,
      night_mode_on_notification:
    )
  end

  describe "#packets", :crc do
    subject(:packets) { night_mode_options.packets }

    it_behaves_like "CRC-wrapped packets", [[0x72, 0x00, 0x08, 0x04]]

    context "when night_mode_deactivate_hours is 12" do
      let(:night_mode_deactivate_hours) { 12 }

      it_behaves_like "CRC-wrapped packets", [[0x72, 0x00, 0x0c, 0x04]]
    end

    context "when night_mode_deactivate_hours is 13" do
      let(:night_mode_deactivate_hours) { 13 }

      it do
        expect { packets }.to raise_error(
          ActiveModel::ValidationError,
          "Validation failed: Night mode deactivate hours 13 is invalid!  Valid night mode deactivate hour values " \
          "are 3..12."
        )
      end
    end

    context "when indiglo_timeout_seconds is 10" do
      let(:indiglo_timeout_seconds) { 10 }

      it_behaves_like "CRC-wrapped packets", [[0x72, 0x00, 0x08, 0x0a]]
    end

    context "when indiglo_timeout_seconds is 11" do
      let(:indiglo_timeout_seconds) { 11 }

      it do
        expect { packets }.to raise_error(
          ActiveModel::ValidationError,
          "Validation failed: Indiglo timeout seconds 11 is invalid!  Valid Indiglo timeout second values are 3..10."
        )
      end
    end

    context "when night_mode_on_notification is 12" do
      let(:night_mode_on_notification) { true }

      it_behaves_like "CRC-wrapped packets", [[0x72, 0x01, 0x08, 0x04]]
    end
  end
end
