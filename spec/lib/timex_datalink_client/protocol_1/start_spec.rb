# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol1::Start do
  let(:start) { described_class.new }

  describe "#packets", :crc do
    subject(:packets) { start.packets }

    it_behaves_like "CRC-wrapped packets", [[0x20, 0x00, 0x00, 0x01]]
  end
end
