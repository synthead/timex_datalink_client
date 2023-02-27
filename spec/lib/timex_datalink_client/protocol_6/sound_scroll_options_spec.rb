# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol6::SoundScrollOptions do
  let(:hourly_chime) { false }
  let(:button_beep) { false }
  let(:scroll_speed) { 1 }

  let(:sound_scroll_options) do
    described_class.new(
      hourly_chime:,
      button_beep:,
      scroll_speed:
    )
  end

  describe "#packets", :crc do
    subject(:packets) { sound_scroll_options.packets }

    it_behaves_like "CRC-wrapped packets", [[0x71, 0x00, 0x00, 0x01]]

    context "when hourly_chime is true" do
      let(:hourly_chime) { true }

      it_behaves_like "CRC-wrapped packets", [[0x71, 0x01, 0x00, 0x01]]
    end

    context "when button_beep is true" do
      let(:button_beep) { true }

      it_behaves_like "CRC-wrapped packets", [[0x71, 0x00, 0x01, 0x01]]
    end

    context "when scroll_speed is 2" do
      let(:scroll_speed) { 2 }

      it_behaves_like "CRC-wrapped packets", [[0x71, 0x00, 0x00, 0x02]]
    end

    context "when scroll_speed is 3" do
      let(:scroll_speed) { 3 }

      it do
        expect { packets }.to raise_error(
          ActiveModel::ValidationError,
          "Validation failed: Scroll speed 3 is invalid!  Valid scroll speed values are 0..2."
        )
      end
    end
  end
end
