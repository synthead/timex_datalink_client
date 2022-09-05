# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Eeprom::Anniversary do
  let(:time) { Time.new(2015, 10, 21) }
  let(:anniversary) { "timexdl.exe modified date" }

  let(:anniversary_instance) do
    described_class.new(
      time: time,
      anniversary: anniversary
    )
  end

  describe "#packet", :length_packet do
    subject(:packet) { anniversary_instance.packet }

    it_behaves_like "a length-prefixed packet", [
      0x0a, 0x15, 0x9d, 0x64, 0x39, 0x61, 0x53, 0xc9, 0x4e, 0xe8, 0x90, 0x16, 0xd6, 0x48, 0x8f, 0xe4, 0x34, 0x64, 0xa3,
      0x74, 0xce, 0x0f
    ]

    context "when time is 1997-9-19" do
      let(:time) { Time.new(1997, 9, 19) }

      it_behaves_like "a length-prefixed packet", [
        0x09, 0x13, 0x9d, 0x64, 0x39, 0x61, 0x53, 0xc9, 0x4e, 0xe8, 0x90, 0x16, 0xd6, 0x48, 0x8f, 0xe4, 0x34, 0x64,
        0xa3, 0x74, 0xce, 0x0f
      ]
    end

    context "when anniversary is \"to the delorean\"" do
      let(:anniversary) { "to the delorean" }

      it_behaves_like "a length-prefixed packet", [
        0x0a, 0x15, 0x1d, 0x46, 0x76, 0x91, 0x43, 0x36, 0x4e, 0x85, 0x6d, 0x8e, 0x72, 0xfd
      ]
    end
  end
end
