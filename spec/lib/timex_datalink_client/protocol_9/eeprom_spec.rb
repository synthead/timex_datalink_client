# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol9::Eeprom do
  let(:chrono) do
    TimexDatalinkClient::Protocol9::Eeprom::Chrono.new(
      label: "MyChrono",
      laps: 25
    )
  end

  let(:phone_numbers) do
    [
      TimexDatalinkClient::Protocol9::Eeprom::PhoneNumber.new(
        name: "marty mcfly",
        number: "1234567890",
        type: "c",
      ),
      TimexDatalinkClient::Protocol9::Eeprom::PhoneNumber.new(
        name: "doc brown",
        number: "1112223333",
        type: "h",
      )
    ]
  end

  let(:eeprom) do
    described_class.new(
      chrono:,
      phone_numbers:
    )
  end

  describe "#packets", :crc do
    subject(:packets) { eeprom.packets }

    it_behaves_like "CRC-wrapped packets", [
      [
        0x70, 0x02, 0x40, 0x05, 0xa9, 0x22, 0x5f, 0xe6, 0xb2, 0xe8, 0xbb, 0xe7, 0xb2, 0xe8, 0xbb, 0xe7, 0xbb, 0xe8,
        0xb2, 0xe7, 0xb2, 0x5c, 0xa3, 0x09, 0x26, 0xed, 0x15, 0xa9, 0x01
      ],
      [0x70, 0x02, 0x5a, 0xa9, 0x02, 0x14, 0xa9, 0xb6, 0xa9, 0xa4, 0x07, 0x47, 0xb7, 0xa9, 0xcc, 0x74, 0x6f],
      [0x23, 0x02, 0x40],
      [0x60, 0x02],
      [
        0x61, 0x01, 0x00, 0x0e, 0x00, 0x72, 0x19, 0x02, 0x16, 0x22, 0x0c, 0x11, 0x1b, 0x18, 0x17, 0x18, 0x10, 0x21,
        0x43, 0x65, 0x87, 0x09, 0xaf, 0x96, 0xb2, 0x75, 0x22, 0x69, 0x31
      ],
      [
        0x61, 0x02, 0x4f, 0x25, 0xfe, 0x0f, 0x11, 0x21, 0x22, 0x33, 0x33, 0xcf, 0x0d, 0xc6, 0x90, 0xcb, 0x86, 0x81,
        0xd7, 0x0f
      ],
      [0x62]
    ]

    context "with no chrono" do
      let(:chrono) { nil }

      it_behaves_like "CRC-wrapped packets", [
        [
          0x70, 0x02, 0x40, 0x05, 0xa9, 0x22, 0x5f, 0xe6, 0xb2, 0xe8, 0xbb, 0xe7, 0xb2, 0xe8, 0xbb, 0xe7, 0xbb, 0xe8,
          0xb2, 0xe7, 0xb2, 0x5c, 0xa3, 0x09, 0x26, 0xed, 0x15, 0xa9, 0x01
        ],
        [0x70, 0x02, 0x5a, 0xa9, 0x02, 0x14, 0xa9, 0xb6, 0xa9, 0xa4, 0x07, 0x47, 0xb7, 0xa9, 0xcc, 0x74, 0x6f],
        [0x23, 0x02, 0x40],
        [0x60, 0x02],
        [
          0x61, 0x01, 0x00, 0x0e, 0x00, 0x16, 0x02, 0x02, 0x24, 0x0c, 0x11, 0x1b, 0x18, 0x17, 0x18, 0x24, 0x10, 0x21,
          0x43, 0x65, 0x87, 0x09, 0xaf, 0x96, 0xb2, 0x75, 0x22, 0x69, 0x31
        ],
        [
          0x61, 0x02, 0x4f, 0x25, 0xfe, 0x0f, 0x11, 0x21, 0x22, 0x33, 0x33, 0xcf, 0x0d, 0xc6, 0x90, 0xcb, 0x86, 0x81,
          0xd7, 0x0f
        ],
        [0x62]
      ]
    end

    context "with all data except phone numbers" do
      let(:phone_numbers) { [] }

      it_behaves_like "CRC-wrapped packets", [
        [
          0x70, 0x02, 0x40, 0x05, 0xa9, 0x22, 0x5f, 0xe6, 0xb2, 0xe8, 0xbb, 0xe7, 0xb2, 0xe8, 0xbb, 0xe7, 0xbb, 0xe8,
          0xb2, 0xe7, 0xb2, 0x5c, 0xa3, 0x09, 0x26, 0xed, 0x15, 0xa9, 0x01
        ],
        [0x70, 0x02, 0x5a, 0xa9, 0x02, 0x14, 0xa9, 0xb6, 0xa9, 0xa4, 0x07, 0x47, 0xb7, 0xa9, 0xcc, 0x74, 0x6f],
        [0x23, 0x02, 0x40],
        [0x60, 0x01],
        [0x61, 0x01, 0x00, 0x0e, 0x00, 0x72, 0x19, 0x00, 0x16, 0x22, 0x0c, 0x11, 0x1b, 0x18, 0x17, 0x18],
        [0x62]
      ]
    end

    context "with no data" do
      let(:chrono) { nil }
      let(:phone_numbers) { [] }

      it_behaves_like "CRC-wrapped packets", [
        [
          0x70, 0x02, 0x40, 0x05, 0xa9, 0x22, 0x5f, 0xe6, 0xb2, 0xe8, 0xbb, 0xe7, 0xb2, 0xe8, 0xbb, 0xe7, 0xbb, 0xe8,
          0xb2, 0xe7, 0xb2, 0x5c, 0xa3, 0x09, 0x26, 0xed, 0x15, 0xa9, 0x01
        ],
        [0x70, 0x02, 0x5a, 0xa9, 0x02, 0x14, 0xa9, 0xb6, 0xa9, 0xa4, 0x07, 0x47, 0xb7, 0xa9, 0xcc, 0x74, 0x6f],
        [0x23, 0x02, 0x40],
        [0x60, 0x01],
        [0x61, 0x01, 0x00, 0x0e, 0x00, 0x16, 0x02, 0x00, 0x24, 0x0c, 0x11, 0x1b, 0x18, 0x17, 0x18, 0x24],
        [0x62]
      ]
    end
  end
end
