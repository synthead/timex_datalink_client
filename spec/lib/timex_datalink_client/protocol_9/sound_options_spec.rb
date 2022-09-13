# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol9::SoundOptions do
  let(:hourly_chime) { false }
  let(:button_beep) { false }

  let(:sound_options) do
    described_class.new(
      hourly_chime: hourly_chime,
      button_beep: button_beep
    )
  end

  describe "#packets", :crc do
    subject(:packets) { sound_options.packets }

    it_behaves_like "CRC-wrapped packets", [[0x32, 0x00]]

    context "when hourly chime is enabled" do
      let(:hourly_chime) { true }

      it_behaves_like "CRC-wrapped packets", [[0x32, 0x01]]
    end

    context "when button beep is enabled" do
      let(:button_beep) { true }

      it_behaves_like "CRC-wrapped packets", [[0x32, 0x02]]
    end

    context "when hourly chime and button beep are enabled" do
      let(:hourly_chime) { true }
      let(:button_beep) { true }

      it_behaves_like "CRC-wrapped packets", [[0x32, 0x03]]
    end
  end
end
