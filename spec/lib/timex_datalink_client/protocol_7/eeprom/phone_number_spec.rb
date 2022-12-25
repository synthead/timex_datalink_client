# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol7::Eeprom::PhoneNumber do
  let(:name) { [0xb1] }
  let(:number) { "0" }

  let(:phone_number) do
    described_class.new(
      name:,
      number:
    )
  end

  describe ".packets" do
    let(:phone_numbers) { [phone_number] }

    subject(:packets) { described_class.packets(phone_numbers) }

    it { should eq([0x01, 0x00, 0x30, 0xb1, 0xfe, 0x00, 0x00, 0x30, 0x01, 0xff, 0x00, 0x00, 0x03]) }

    context "with no phone numbers" do
      let(:phone_numbers) { [] }

      it { should eq([0x00, 0x00, 0x03]) }
    end

    context "with two phone numbers" do
      let(:phone_number_2) do
        described_class.new(
          name: [0xb1, 0xb2, 0xb3],
          number: "1234567890"
        )
      end

      let(:phone_numbers) { [phone_number, phone_number_2] }

      it do
        should eq [
          0x02, 0x00, 0x30, 0xb1, 0xfe, 0x00, 0x00, 0x30, 0x01, 0xfe, 0x00, 0x00, 0x03, 0xb1, 0xb2, 0xb3, 0xfe, 0x00,
          0x02, 0x03, 0x04, 0x05, 0x00, 0x06, 0x07, 0x08, 0x09, 0x0c, 0x0a, 0x01, 0xff, 0x00, 0x03
        ]
      end
    end
  end

  describe "#name_and_number" do
    subject(:name_and_number) { phone_number.name_and_number }

    it { should eq([[177], [1]]) }

    context "when name is [0xb1, 0xb2, 0xb3]" do
      let(:name) { [0xb1, 0xb2, 0xb3] }

      it { should eq([[177, 178, 179], [1]]) }
    end

    context "when number is \"1234567890\"" do
      let(:number) { "1234567890" }

      it { should eq([[177], [2, 3, 4, 5, 6, 7, 8, 9, 10, 1]]) }
    end
  end
end
