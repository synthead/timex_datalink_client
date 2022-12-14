# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol3::Eeprom::PhoneNumber do
  let(:name) { "Marty McFly" }
  let(:number) { "1234567890" }
  let(:type) { "c" }

  let(:phone_number) do
    described_class.new(
      name:,
      number:,
      type:
    )
  end

  describe "#packet", :length_packet do
    subject(:packet) { phone_number.packet }

    it_behaves_like "a length-prefixed packet", [
      0x21, 0x43, 0x65, 0x87, 0x09, 0xaf, 0x96, 0xb2, 0x75, 0x22, 0x69, 0x31, 0x4f, 0x25, 0xfe
    ]

    context "when name is \"Doc Brown with More than 31 Characters\"" do
      let(:name) { "Doc Brown with More than 31 Characters" }

      it_behaves_like "a length-prefixed packet", [
        0x21, 0x43, 0x65, 0x87, 0x09, 0xaf, 0x0d, 0xc6, 0x90, 0xcb, 0x86, 0x81, 0x17, 0x09, 0x4a, 0x5d, 0x44, 0x5a,
        0xd8, 0xe6, 0x90, 0x5d, 0xa4, 0x5c, 0xe4, 0x10, 0x90, 0x4c, 0xa4, 0xfc
      ]
    end

    context "when name is \";@_|<>[]\"" do
      let(:name) { ";@_|<>[]" }

      it_behaves_like "a length-prefixed packet", [
        0x21, 0x43, 0x65, 0x87, 0x09, 0xaf, 0x36, 0xae, 0xef, 0x7c, 0xef, 0x93, 0x3f
      ]
    end

    context "when name is \"~with~invalid~characters\"" do
      let(:name) { "~with~invalid~characters" }

      it_behaves_like "a length-prefixed packet", [
        0x21, 0x43, 0x65, 0x87, 0x09, 0xaf, 0x24, 0x28, 0x75, 0x11, 0x29, 0x5d, 0x9f, 0x52, 0x49, 0x0d, 0xc9, 0x44,
        0xca, 0xa6, 0x30, 0x9d, 0xb3, 0x71, 0x3f
      ]
    end

    context "when number is \"123\"" do
      let(:number) { "123" }

      it_behaves_like "a length-prefixed packet", [
        0xff, 0xff, 0xff, 0x1f, 0x32, 0xaf, 0x96, 0xb2, 0x75, 0x22, 0x69, 0x31, 0x4f, 0x25, 0xfe
      ]
    end

    context "when number is \"12345678901234567890\"" do
      let(:number) { "12345678901234567890" }

      it_behaves_like "a length-prefixed packet", [
        0x21, 0x43, 0x65, 0x87, 0x09, 0x21, 0x96, 0xb2, 0x75, 0x22, 0x69, 0x31, 0x4f, 0x25, 0xfe
      ]
    end

    context "when number is \"1~2~3\"" do
      let(:number) { "1~2~3" }

      it_behaves_like "a length-prefixed packet", [
        0xff, 0xff, 0x1f, 0x2f, 0x3f, 0xaf, 0x96, 0xb2, 0x75, 0x22, 0x69, 0x31, 0x4f, 0x25, 0xfe
      ]
    end

    context "when type is \"H\"" do
      let(:type) { "H" }

      it_behaves_like "a length-prefixed packet", [
        0x21, 0x43, 0x65, 0x87, 0x09, 0xcf, 0x96, 0xb2, 0x75, 0x22, 0x69, 0x31, 0x4f, 0x25, 0xfe
      ]
    end

    context "when type is \"~\"" do
      let(:type) { "~" }

      it_behaves_like "a length-prefixed packet", [
        0x21, 0x43, 0x65, 0x87, 0x09, 0xff, 0x96, 0xb2, 0x75, 0x22, 0x69, 0x31, 0x4f, 0x25, 0xfe
      ]
    end
  end
end
