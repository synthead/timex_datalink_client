# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol9::End do
  let(:end_instance) { described_class.new }

  describe "#packets", :crc do
    subject(:packets) { end_instance.packets }

    it_behaves_like "CRC-wrapped packets", [[0x21]]
  end
end
