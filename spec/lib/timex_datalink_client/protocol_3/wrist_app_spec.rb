# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol3::WristApp do
  let(:wrist_app) do
    described_class.new(
      wrist_app_data: wrist_app_data,
      zap_file: zap_file
    )
  end

  describe "#packets", :crc do
    subject(:packets) { wrist_app.packets }

    context "when wrist_app_data contains WristApp data" do
      let(:wrist_app_data) do
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et " \
        "dolore magna aliqua."
      end

      let(:zap_file) { nil }

      it_behaves_like "CRC-wrapped packets", [
        [0x93, 0x02],
        [0x90, 0x02, 0x04, 0x01],
        [
          0x91, 0x02, 0x01, 0x4c, 0x6f, 0x72, 0x65, 0x6d, 0x20, 0x69, 0x70, 0x73, 0x75, 0x6d, 0x20, 0x64, 0x6f, 0x6c,
          0x6f, 0x72, 0x20, 0x73, 0x69, 0x74, 0x20, 0x61, 0x6d, 0x65, 0x74, 0x2c, 0x20, 0x63, 0x6f, 0x6e, 0x73
        ],
        [
          0x91, 0x02, 0x02, 0x65, 0x63, 0x74, 0x65, 0x74, 0x75, 0x72, 0x20, 0x61, 0x64, 0x69, 0x70, 0x69, 0x73, 0x63,
          0x69, 0x6e, 0x67, 0x20, 0x65, 0x6c, 0x69, 0x74, 0x2c, 0x20, 0x73, 0x65, 0x64, 0x20, 0x64, 0x6f, 0x20
        ],
        [
          0x91, 0x02, 0x03, 0x65, 0x69, 0x75, 0x73, 0x6d, 0x6f, 0x64, 0x20, 0x74, 0x65, 0x6d, 0x70, 0x6f, 0x72, 0x20,
          0x69, 0x6e, 0x63, 0x69, 0x64, 0x69, 0x64, 0x75, 0x6e, 0x74, 0x20, 0x75, 0x74, 0x20, 0x6c, 0x61, 0x62
        ],
        [
          0x91, 0x02, 0x04, 0x6f, 0x72, 0x65, 0x20, 0x65, 0x74, 0x20, 0x64, 0x6f, 0x6c, 0x6f, 0x72, 0x65, 0x20, 0x6d,
          0x61, 0x67, 0x6e, 0x61, 0x20, 0x61, 0x6c, 0x69, 0x71, 0x75, 0x61, 0x2e
        ],
        [0x92, 0x02]
      ]
    end

    context "when zap_file contains a ZAP file path" do
      let(:wrist_app_data) { nil }
      let(:zap_file) { "spec/fixtures/EXAMPLE.ZAP" }

      it_behaves_like "CRC-wrapped packets", [
        [0x93, 0x02],
        [0x90, 0x02, 0x05, 0x01],
        [
          0x91, 0x02, 0x01, 0x31, 0x35, 0x30, 0x20, 0x64, 0x61, 0x74, 0x61, 0x3a, 0x20, 0x4c, 0x6f, 0x72, 0x65, 0x6d,
          0x20, 0x69, 0x70, 0x73, 0x75, 0x6d, 0x20, 0x64, 0x6f, 0x6c, 0x6f, 0x72, 0x20, 0x73, 0x69, 0x74, 0x20
        ],
        [
          0x91, 0x02, 0x02, 0x61, 0x6d, 0x65, 0x74, 0x2c, 0x20, 0x63, 0x6f, 0x6e, 0x73, 0x65, 0x63, 0x74, 0x65, 0x74,
          0x75, 0x72, 0x20, 0x61, 0x64, 0x69, 0x70, 0x69, 0x73, 0x63, 0x69, 0x6e, 0x67, 0x20, 0x65, 0x6c, 0x69
        ],
        [
          0x91, 0x02, 0x03, 0x74, 0x2c, 0x20, 0x73, 0x65, 0x64, 0x20, 0x64, 0x6f, 0x20, 0x65, 0x69, 0x75, 0x73, 0x6d,
          0x6f, 0x64, 0x20, 0x74, 0x65, 0x6d, 0x70, 0x6f, 0x72, 0x20, 0x69, 0x6e, 0x63, 0x69, 0x64, 0x69, 0x64
        ],
        [
          0x91, 0x02, 0x04, 0x75, 0x6e, 0x74, 0x20, 0x75, 0x74, 0x20, 0x6c, 0x61, 0x62, 0x6f, 0x72, 0x65, 0x20, 0x65,
          0x74, 0x20, 0x64, 0x6f, 0x6c, 0x6f, 0x72, 0x65, 0x20, 0x6d, 0x61, 0x67, 0x6e, 0x61, 0x20, 0x61, 0x6c
        ],
        [0x91, 0x02, 0x05, 0x69, 0x71, 0x75, 0x61, 0x2e],
        [0x92, 0x02]
      ]
    end
  end
end
