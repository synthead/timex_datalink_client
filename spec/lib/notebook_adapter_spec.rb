# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::NotebookAdapter do
  let(:serial_device) { "/some/serial/device" }
  let(:byte_sleep) { 0.006 }
  let(:packet_sleep) { 0.06 }
  let(:verbose) { false }

  subject(:notebook_adapter) do
    described_class.new(
      serial_device: serial_device,
      byte_sleep: byte_sleep,
      packet_sleep: packet_sleep,
      verbose: verbose
    )
  end

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

      packets.each do |packet|
        packet.each do |byte|
          expect(serial_double).to receive(:write).with(byte.chr).ordered
          expect(notebook_adapter).to receive(:sleep).with(byte_sleep).ordered
        end

        expect(notebook_adapter).to receive(:sleep).with(packet_sleep).ordered
      end

      notebook_adapter.write(packets)
    end

    it "does not write to console" do
      allow(Serial).to receive(:new).with(serial_device).and_return(serial_double)
      allow(serial_double).to receive(:write)
      allow(notebook_adapter).to receive(:sleep)

      expect(notebook_adapter).to_not receive(:printf)
      expect(notebook_adapter).to_not receive(:puts)

      notebook_adapter.write(packets)
    end

    context "when verbose is true" do
      let(:verbose) { true }

      it "writes serial data with console output" do
        expect(Serial).to receive(:new).with(serial_device).and_return(serial_double)

        packets.each do |packet|
          packet.each do |byte|
            expect(notebook_adapter).to receive(:printf).with("%.2X ", byte).ordered
            expect(serial_double).to receive(:write).ordered
            expect(notebook_adapter).to receive(:sleep).ordered
          end

          expect(notebook_adapter).to receive(:sleep).ordered
          expect(notebook_adapter).to receive(:puts).ordered
        end

        notebook_adapter.write(packets)
      end
    end
  end
end
