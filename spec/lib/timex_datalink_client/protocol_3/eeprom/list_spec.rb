# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol3::Eeprom::List do
  let(:list_entry) { "Muffler Bearings" }
  let(:priority) { nil }

  let(:list) do
    described_class.new(
      list_entry:,
      priority:
    )
  end

  describe "#packet", :length_packet do
    subject(:packet) { list.packet }

    it_behaves_like "a length-prefixed packet", [
      0x00, 0x96, 0xf7, 0x3c, 0x95, 0xb3, 0x91, 0x8b, 0xa3, 0x6c, 0xd2, 0x05, 0x71, 0x3f
    ]

    context "when priority is 1" do
      let(:priority) { 1 }

      it_behaves_like "a length-prefixed packet", [
        0x01, 0x96, 0xf7, 0x3c, 0x95, 0xb3, 0x91, 0x8b, 0xa3, 0x6c, 0xd2, 0x05, 0x71, 0x3f
      ]
    end

    context "when priority is 5" do
      let(:priority) { 5 }

      it_behaves_like "a length-prefixed packet", [
        0x05, 0x96, 0xf7, 0x3c, 0x95, 0xb3, 0x91, 0x8b, 0xa3, 0x6c, 0xd2, 0x05, 0x71, 0x3f
      ]
    end

    context "when priority is 0" do
      let(:priority) { 0 }

      it do
        expect { packet }.to raise_error(
          ActiveModel::ValidationError,
          "Validation failed: Priority 0 is invalid!  Valid priorities are 1..5 or nil."
        )
      end
    end

    context "when priority is 6" do
      let(:priority) { 6 }

      it do
        expect { packet }.to raise_error(
          ActiveModel::ValidationError,
          "Validation failed: Priority 6 is invalid!  Valid priorities are 1..5 or nil."
        )
      end
    end

    context "when list_entry is \"Headlight Fluid with More than 31 Characters\"" do
      let(:list_entry) { "Headlight Fluid with More than 31 Characters" }

      it_behaves_like "a length-prefixed packet", [
        0x00, 0x91, 0xa3, 0x34, 0x95, 0x04, 0x45, 0x1d, 0xf9, 0x54, 0x9e, 0xd4, 0x90, 0xa0, 0xd4, 0x45, 0xa4, 0x85,
        0x6d, 0x0e, 0xd9, 0x45, 0xca, 0x45, 0xfe
      ]
    end

    context "when list_entry is \";@_|<>[]\"" do
      let(:list_entry) { ";@_|<>[]" }

      it_behaves_like "a length-prefixed packet", [
        0x00, 0x36, 0xae, 0xef, 0x7c, 0xef, 0x93, 0x3f
      ]
    end

    context "when list_entry is \"~with~invalid~characters\"" do
      let(:list_entry) { "~with~invalid~characters" }

      it_behaves_like "a length-prefixed packet", [
        0x00, 0x24, 0x28, 0x75, 0x11, 0x29, 0x5d, 0x9f, 0x52, 0x49, 0x0d, 0xc9, 0x44, 0xca, 0xa6, 0x30, 0x9d, 0xb3,
        0x71, 0x3f
      ]
    end
  end
end
