# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol4::SoundTheme do
  let(:sound_theme) do
    described_class.new(
      sound_theme_data:,
      spc_file:
    )
  end

  describe "#packets", :crc do
    subject(:packets) { sound_theme.packets }

    context "when sound_theme_data contains data" do
      let(:sound_theme_data) { "binary sound data that gets sent verbatim" }
      let(:spc_file) { nil }

      it_behaves_like "CRC-wrapped packets", [
        [0x90, 0x03, 0x02, 0xd7],
        [
          0x91, 0x03, 0x01, 0x62, 0x69, 0x6e, 0x61, 0x72, 0x79, 0x20, 0x73, 0x6f, 0x75, 0x6e, 0x64, 0x20, 0x64, 0x61,
          0x74, 0x61, 0x20, 0x74, 0x68, 0x61, 0x74, 0x20, 0x67, 0x65, 0x74, 0x73, 0x20, 0x73, 0x65, 0x6e, 0x74
        ],
        [0x91, 0x03, 0x02, 0x20, 0x76, 0x65, 0x72, 0x62, 0x61, 0x74, 0x69, 0x6d],
        [0x92, 0x03]
      ]
    end

    context "when spc_file contains a SPC file path" do
      let(:sound_theme_data) { nil }
      let(:spc_file) { "spec/fixtures/EXAMPLE.SPC" }

      it_behaves_like "CRC-wrapped packets", [
        [0x90, 0x03, 0x02, 0xd7],
        [
          0x91, 0x03, 0x01, 0x62, 0x69, 0x6e, 0x61, 0x72, 0x79, 0x20, 0x73, 0x6f, 0x75, 0x6e, 0x64, 0x20, 0x64, 0x61,
          0x74, 0x61, 0x20, 0x74, 0x68, 0x61, 0x74, 0x20, 0x67, 0x65, 0x74, 0x73, 0x20, 0x73, 0x65, 0x6e, 0x74
        ],
        [0x91, 0x03, 0x02, 0x20, 0x76, 0x65, 0x72, 0x62, 0x61, 0x74, 0x69, 0x6d],
        [0x92, 0x03]
      ]
    end
  end
end
