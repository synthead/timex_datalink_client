# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol6::PagerOptions do
  let(:auto_on_off) { false }
  let(:on_hour) { 12 }
  let(:on_minute) { 34 }
  let(:off_hour) { 18 }
  let(:off_minute) { 56 }
  let(:alert_sound) { 0 }

  let(:pager_options) do
    described_class.new(
      auto_on_off:,
      on_hour:,
      on_minute:,
      off_hour:,
      off_minute:,
      alert_sound:
    )
  end

  describe "#packets", :crc do
    subject(:packets) { pager_options.packets }

    it_behaves_like "CRC-wrapped packets", [[0x73, 0x00, 0x0c, 0x22, 0x12, 0x38, 0x00]]

    context "when auto_on_off is true" do
      let(:auto_on_off) { true }

      it_behaves_like "CRC-wrapped packets", [[0x73, 0x01, 0x0c, 0x22, 0x12, 0x38, 0x00]]
    end

    context "when on_hour is 6" do
      let(:on_hour) { 6 }

      it_behaves_like "CRC-wrapped packets", [[0x73, 0x00, 0x06, 0x22, 0x12, 0x38, 0x00]]
    end

    context "when on_hour is 25" do
      let(:on_hour) { 25 }

      it do
        expect { packets }.to raise_error(
          ActiveModel::ValidationError,
          "Validation failed: On hour 25 is invalid!  Valid on hour values are 0..23."
        )
      end
    end

    context "when on_minute is 3" do
      let(:on_minute) { 3 }

      it_behaves_like "CRC-wrapped packets", [[0x73, 0x00, 0x0c, 0x03, 0x12, 0x38, 0x00]]
    end

    context "when on_minute is 60" do
      let(:on_minute) { 60 }

      it do
        expect { packets }.to raise_error(
          ActiveModel::ValidationError,
          "Validation failed: On minute 60 is invalid!  Valid on minute values are 0..59."
        )
      end
    end

    context "when off_hour is 4" do
      let(:off_hour) { 4 }

      it_behaves_like "CRC-wrapped packets", [[0x73, 0x00, 0x0c, 0x22, 0x04, 0x38, 0x00]]
    end

    context "when off_hour is 25" do
      let(:off_hour) { 25 }

      it do
        expect { packets }.to raise_error(
          ActiveModel::ValidationError,
          "Validation failed: Off hour 25 is invalid!  Valid off hour values are 0..23."
        )
      end
    end

    context "when off_minute is 9" do
      let(:off_minute) { 9 }

      it_behaves_like "CRC-wrapped packets", [[0x73, 0x00, 0x0c, 0x22, 0x12, 0x09, 0x00]]
    end

    context "when off_minute is 60" do
      let(:off_minute) { 60 }

      it do
        expect { packets }.to raise_error(
          ActiveModel::ValidationError,
          "Validation failed: Off minute 60 is invalid!  Valid off minute values are 0..59."
        )
      end
    end

    context "when alert_sound is 3" do
      let(:alert_sound) { 3 }

      it_behaves_like "CRC-wrapped packets", [[0x73, 0x00, 0x0c, 0x22, 0x12, 0x38, 0x03]]
    end

    context "when alert_sound is nil" do
      let(:alert_sound) { nil }

      it_behaves_like "CRC-wrapped packets", [[0x73, 0x00, 0x0c, 0x22, 0x12, 0x38, 0x06]]
    end

    context "when alert_sound is 6" do
      let(:alert_sound) { 6 }

      it do
        expect { packets }.to raise_error(
          ActiveModel::ValidationError,
          "Validation failed: Alert sound 6 is invalid!  Valid alert sound values are 0..5 and nil."
        )
      end
    end
  end
end
