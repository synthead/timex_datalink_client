# frozen_string_literal: true

require "spec_helper"

require "timex_datalink_client/sound_options"

describe TimexDatalinkClient::SoundOptions do
  let(:sound_options) do
    described_class.new(
      hourly_chimes: hourly_chimes,
      button_beep: button_beep
    )
  end

  describe "#packets", :crc do
    subject(:packets) { sound_options.packets }

    context "when no sounds are enabled" do
      let(:hourly_chimes) { 0 }
      let(:button_beep) { 0 }

      it_behaves_like "CRC-wrapped packets", [[0x71, 0x00, 0x00]]
    end

    context "when hourly chimes are enabled" do
      let(:hourly_chimes) { 1 }
      let(:button_beep) { 0 }

      it_behaves_like "CRC-wrapped packets", [[0x71, 0x01, 0x00]]
    end

    context "when button beep is enabled" do
      let(:hourly_chimes) { 0 }
      let(:button_beep) { 1 }

      it_behaves_like "CRC-wrapped packets", [[0x71, 0x00, 0x01]]
    end

    context "when hourly chimes and button beep are enabled" do
      let(:hourly_chimes) { 1 }
      let(:button_beep) { 1 }

      it_behaves_like "CRC-wrapped packets", [[0x71, 0x01, 0x01]]
    end
  end
end
