# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol3::Eeprom::Anniversary do
  let(:time) { Time.new(1997, 9, 19) }
  let(:anniversary) { "TIMEXDL.EXE modified date" }

  let(:anniversary_instance) do
    described_class.new(
      time:,
      anniversary:
    )
  end

  describe "#packet", :length_packet do
    subject(:packet) { anniversary_instance.packet }

    it_behaves_like "a length-prefixed packet", [
      0x09, 0x13, 0x9d, 0x64, 0x39, 0x61, 0x53, 0xc9, 0x4e, 0xe8, 0x90, 0x16, 0xd6, 0x48, 0x8f, 0xe4, 0x34, 0x64, 0xa3,
      0x74, 0xce, 0x0f
    ]

    context "when time is 2015-10-21" do
      let(:time) { Time.new(2015, 10, 21) }

      it_behaves_like "a length-prefixed packet", [
        0x0a, 0x15, 0x9d, 0x64, 0x39, 0x61, 0x53, 0xc9, 0x4e, 0xe8, 0x90, 0x16, 0xd6, 0x48, 0x8f, 0xe4, 0x34, 0x64,
        0xa3, 0x74, 0xce, 0x0f
      ]
    end

    context "when anniversary is \"To the Delorean with More Than 31 Characters\"" do
      let(:anniversary) { "To the Delorean with More Than 31 Characters" }

      it_behaves_like "a length-prefixed packet", [
        0x09, 0x13, 0x1d, 0x46, 0x76, 0x91, 0x43, 0x36, 0x4e, 0x85, 0x6d, 0x8e, 0x72, 0x91, 0xa0, 0xd4, 0x45, 0xa4,
        0x85, 0x6d, 0x0e, 0xd9, 0x45, 0xca, 0x45, 0xfe
      ]
    end

    context "when anniversary is \";@_|<>[]\"" do
      let(:anniversary) { ";@_|<>[]" }

      it_behaves_like "a length-prefixed packet", [
        0x09, 0x13, 0x36, 0xae, 0xef, 0x7c, 0xef, 0x93, 0x3f
      ]
    end

    context "when anniversary is \"~with~invalid~characters\"" do
      let(:anniversary) { "~with~invalid~characters" }

      it_behaves_like "a length-prefixed packet", [
        0x09, 0x13, 0x24, 0x28, 0x75, 0x11, 0x29, 0x5d, 0x9f, 0x52, 0x49, 0x0d, 0xc9, 0x44, 0xca, 0xa6, 0x30, 0x9d,
        0xb3, 0x71, 0x3f
      ]
    end
  end
end
