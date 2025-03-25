# frozen_string_literal: true

require "tzinfo"

require "spec_helper"

describe TimexDatalinkClient do
  let(:serial_device) { "/some/serial/device" }
  let(:byte_sleep) { 0.006 }
  let(:packet_sleep) { 0.06 }
  let(:verbose) { false }

  let(:models) do
    [
      TimexDatalinkClient::Protocol3::Sync.new(length: 50),
      TimexDatalinkClient::Protocol3::Start.new,
      TimexDatalinkClient::Protocol3::Time.new(
        zone: 1,
        is_24h: false,
        date_format: "%_m-%d-%y",
        time: TZInfo::Timezone.get("US/Pacific").local_time(2015, 10, 21, 19, 28, 32)
      ),
      TimexDatalinkClient::Protocol3::Eeprom.new(
        appointments: [
          TimexDatalinkClient::Protocol3::Eeprom::Appointment.new(
            time: Time.new(1997, 9, 19),
            message: "release timexdl.exe"
          )
        ],
        appointment_notification_minutes: 0
      ),
      TimexDatalinkClient::Protocol3::End.new
    ]
  end

  let(:timex_datalink_client) do
    described_class.new(
      serial_device:,
      models:,
      byte_sleep:,
      packet_sleep:,
      verbose:
    )
  end

  let(:packets) do
    [
      [
        0x78, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55,
        0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55,
        0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0xaa, 0xaa, 0xaa,
        0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
        0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa
      ],
      [0x07, 0x20, 0x00, 0x00, 0x03, 0x01, 0xfe],
      [0x11, 0x32, 0x01, 0x20, 0x13, 0x1c, 0x0a, 0x15, 0x0f, 0x19, 0x0d, 0x1d, 0x02, 0x01, 0x00, 0x89, 0x32],
      [0x05, 0x93, 0x01, 0x31, 0xbd],
      [
        0x14, 0x90, 0x01, 0x01, 0x02, 0x36, 0x02, 0x49, 0x02, 0x49, 0x02, 0x49, 0x01, 0x00, 0x00, 0x00, 0x61, 0x00,
        0x22, 0x6b
      ],
      [
        0x19, 0x91, 0x01, 0x01, 0x13, 0x09, 0x13, 0x00, 0x9b, 0x53, 0x39, 0x0a, 0xe7, 0x90, 0x9d, 0x64, 0x39, 0x61,
        0x53, 0xc9, 0x4e, 0xe8, 0xfc, 0x99, 0xed
      ],
      [0x05, 0x92, 0x01, 0xa1, 0xbc],
      [0x04, 0x21, 0xd8, 0xc2]
    ]
  end

  describe "VERSION" do
    subject(:version) { described_class::VERSION }

    it { should eq("0.12.4") }
  end

  describe "#write" do
    let(:notebook_adapter_double) { instance_double(TimexDatalinkClient::NotebookAdapter) }

    subject(:write) { timex_datalink_client.write }

    it "passes the correct serial device to NotebookAdapter#new" do
      allow(notebook_adapter_double).to receive(:write)

      expect(TimexDatalinkClient::NotebookAdapter).to receive(:new).with(
        serial_device:,
        byte_sleep:,
        packet_sleep:,
        verbose:
      ).and_return(notebook_adapter_double)

      write
    end

    it "calls NotebookAdapter#write with all model packets" do
      allow(TimexDatalinkClient::NotebookAdapter).to receive(:new).and_return(notebook_adapter_double)
      expect(notebook_adapter_double).to receive(:write).with(packets)

      write
    end
  end

  describe "#packets" do
    subject(:packets) { timex_datalink_client.packets }

    it { should eq(packets) }
  end
end
