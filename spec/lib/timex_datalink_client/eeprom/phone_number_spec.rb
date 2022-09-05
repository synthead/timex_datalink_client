# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Eeprom::PhoneNumber do
  let(:name) { "marty mcfly" }
  let(:number) { "1234567890" }
  let(:type) { "c" }

  let(:phone_number) do
    described_class.new(
      name: name,
      number: number,
      type: type,
    )
  end

  describe "#packet", :length_packet do
    subject(:packet) { phone_number.packet }

    it_behaves_like "a length-prefixed packet", [
      0x21, 0x43, 0x65, 0x87, 0x09, 0xaf, 0x96, 0xb2, 0x75, 0x22, 0x69, 0x31, 0x4f, 0x25, 0xfe
    ]

    context "when name is \"doc brown\"" do
      let(:name) { "doc brown" }

      it_behaves_like "a length-prefixed packet", [
        0x21, 0x43, 0x65, 0x87, 0x09, 0xaf, 0x0d, 0xc6, 0x90, 0xcb, 0x86, 0x81, 0xd7, 0x0f
      ]
    end

    context "when number is 123" do
      let(:number) { "123" }

      it_behaves_like "a length-prefixed packet", [
        0xff, 0xff, 0xff, 0x1f, 0x32, 0xaf, 0x96, 0xb2, 0x75, 0x22, 0x69, 0x31, 0x4f, 0x25, 0xfe
      ]
    end

    context "when number is 123456789012" do
      let(:number) { "123456789012" }

      it_behaves_like "a length-prefixed packet", [
        0x21, 0x43, 0x65, 0x87, 0x09, 0x21, 0x96, 0xb2, 0x75, 0x22, 0x69, 0x31, 0x4f, 0x25, 0xfe
      ]
    end

    context "when type is \"h\"" do
      let(:type) { "h" }

      it_behaves_like "a length-prefixed packet", [
        0x21, 0x43, 0x65, 0x87, 0x09, 0xcf, 0x96, 0xb2, 0x75, 0x22, 0x69, 0x31, 0x4f, 0x25, 0xfe
      ]
    end
  end
end
