# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::NotebookAdapter do
  let(:serial_device) { "/dev/ttyACM0" }
  subject(:notebook_adapter) { described_class.new(serial_device) }

  describe "#write" do
    let(:packets) do
      [
        [0x00, 0x01, 0x02],
        [0x03, 0x04, 0x05]
      ]
    end

    let(:serial_double) { instance_double(Serial) }

    it "writes serial data with correct sleep lengths" do
      expect(Serial).to receive(:new).with(serial_device).and_return(serial_double)

      ["\x00\x01\x02", "\x03\x04\x05"].each do |packet|
        packet.each_char do |char|
          expect(serial_double).to receive(:write).with(char).ordered
          expect(notebook_adapter).to receive(:sleep).with(0.025).ordered
        end

        expect(notebook_adapter).to receive(:sleep).with(0.25).ordered
      end

      notebook_adapter.write(packets)
    end
  end
end
