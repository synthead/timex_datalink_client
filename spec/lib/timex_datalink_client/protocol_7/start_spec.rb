# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol7::Start do
  let(:start) { described_class.new }

  describe "#packets", :crc do
    subject(:packets) { start.packets }

    it_behaves_like "CRC-wrapped packets", [
      [0x20, 0x00, 0x00, 0x07],
      [
        0x90, 0x05, 0x01, 0x44, 0x53, 0x49, 0x20, 0x54, 0x6f, 0x79, 0x73, 0x20, 0x70, 0x72, 0x65, 0x73, 0x65, 0x6e,
        0x74, 0x73, 0x2e, 0x2e, 0x2e, 0x65, 0x42, 0x72, 0x61, 0x69, 0x6e, 0x21, 0x00, 0x00, 0x00, 0x00, 0x00
      ],
      [0x91, 0x05, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04]
    ]
  end
end
