# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol7::Eeprom do
  let(:activities) { nil }
  let(:games) { nil }
  let(:calendar) { nil }
  let(:phone_numbers) { nil }
  let(:speech) { nil }

  let(:eeprom) do
    described_class.new(
      activities: activities,
      games: games,
      calendar: calendar,
      phone_numbers: phone_numbers,
      speech: speech
    )
  end

  describe "#packets", :crc do
    subject(:packets) { eeprom.packets }

    context "with activities present" do
      let(:activities) do
        [
          TimexDatalinkClient::Protocol7::Eeprom::Activity.new(
            time: Time.new(0, 1, 1, 1, 30, 0),
            messages: [[0xb1]],
            random_speech: false
          ),
          TimexDatalinkClient::Protocol7::Eeprom::Activity.new(
            time: Time.new(0, 1, 1, 2, 30, 0),
            messages: [[0xb1], [0xb2], [0xb3]],
            random_speech: true
          )
        ]
      end

      it_behaves_like "CRC-wrapped packets", [
        [
          0x90, 0x05, 0x02, 0x44, 0x53, 0x49, 0x20, 0x54, 0x6f, 0x79, 0x73, 0x20, 0x70, 0x72, 0x65, 0x73, 0x65, 0x6e,
          0x74, 0x73, 0x2e, 0x2e, 0x2e, 0x65, 0x42, 0x72, 0x61, 0x69, 0x6e, 0x21, 0x00, 0x00, 0x00, 0x00, 0x00
        ],
        [
          0x91, 0x05, 0x01, 0x02, 0x00, 0x00, 0x00, 0x02, 0x00, 0x01, 0x1e, 0x01, 0x10, 0x00, 0x02, 0x1e, 0x03, 0x15,
          0x00, 0x30, 0xb1, 0xff, 0x00, 0x00, 0x30, 0xb1, 0xfe, 0x00, 0x00, 0x30, 0xb2, 0xfe, 0x00, 0x00, 0x30
        ],
        [0x91, 0x05, 0x02, 0xb3, 0xff, 0x00, 0x00, 0x04],
        [0x92, 0x05]
      ]
    end

    context "with games present" do
      let(:games) do
        TimexDatalinkClient::Protocol7::Eeprom::Games.new(
          countdown_timer_enabled: true,
          countdown_timer_seconds: 120,
          countdown_timer_sound: 0x069,
          mind_reader_enabled: true,
          music_time_keeper_enabled: true,
          music_time_keeper_sound: 0x069
        )
      end

      it_behaves_like "CRC-wrapped packets", [
        [
          0x90, 0x05, 0x01, 0x44, 0x53, 0x49, 0x20, 0x54, 0x6f, 0x79, 0x73, 0x20, 0x70, 0x72, 0x65, 0x73, 0x65, 0x6e,
          0x74, 0x73, 0x2e, 0x2e, 0x2e, 0x65, 0x42, 0x72, 0x61, 0x69, 0x6e, 0x21, 0x00, 0x00, 0x00, 0x00, 0x00
        ],
        [0x91, 0x05, 0x01, 0x1c, 0x00, 0xb0, 0x04, 0x30, 0x69, 0xfe, 0x00, 0x00, 0x30, 0x69, 0xfe, 0x00, 0x00, 0x02],
        [0x92, 0x05]
      ]
    end

    context "with calendar present" do
      let(:events) do
        [
          TimexDatalinkClient::Protocol7::Eeprom::Calendar::Event.new(
            time: Time.new(2022, 12, 15, 3, 30, 0),
            phrase: [0x069]
          ),
          TimexDatalinkClient::Protocol7::Eeprom::Calendar::Event.new(
            time: Time.new(2022, 12, 20, 5, 0, 0),
            phrase: [0x064]
          )
        ]
      end

      let(:calendar) do
        TimexDatalinkClient::Protocol7::Eeprom::Calendar.new(
          time: Time.new(2022, 12, 10, 1, 30, 0),
          events: events
        )
      end

      it_behaves_like "CRC-wrapped packets", [
        [
          0x90, 0x05, 0x01, 0x44, 0x53, 0x49, 0x20, 0x54, 0x6f, 0x79, 0x73, 0x20, 0x70, 0x72, 0x65, 0x73, 0x65, 0x6e,
          0x74, 0x73, 0x2e, 0x2e, 0x2e, 0x65, 0x42, 0x72, 0x61, 0x69, 0x6e, 0x21, 0x00, 0x00, 0x00, 0x00, 0x00
        ],
        [
          0x91, 0x05, 0x01, 0x02, 0x00, 0xca, 0x05, 0x0a, 0x00, 0x7c, 0x0b, 0x0f, 0x00, 0x30, 0x69, 0xfe, 0x00, 0x00,
          0x30, 0x64, 0xff, 0x00, 0x00, 0x01, 0x1e, 0xbb, 0x20, 0x12, 0x00, 0x01
        ],
        [0x92, 0x05]
      ]
    end

    context "with phone numbers present" do
      let(:phone_numbers) do
        [
          TimexDatalinkClient::Protocol7::Eeprom::PhoneNumber.new(
            name: [0xb1, 0xb2, 0xb3],
            number: "1234567890"
          ),
          TimexDatalinkClient::Protocol7::Eeprom::PhoneNumber.new(
            name: [0xb1, 0xb2, 0xb3],
            number: "1234567890"
          )
        ]
      end

      it_behaves_like "CRC-wrapped packets", [
        [
          0x90, 0x05, 0x02, 0x44, 0x53, 0x49, 0x20, 0x54, 0x6f, 0x79, 0x73, 0x20, 0x70, 0x72, 0x65, 0x73, 0x65, 0x6e,
          0x74, 0x73, 0x2e, 0x2e, 0x2e, 0x65, 0x42, 0x72, 0x61, 0x69, 0x6e, 0x21, 0x00, 0x00, 0x00, 0x00, 0x00
        ],
        [
          0x91, 0x05, 0x01, 0x02, 0x00, 0x03, 0xb1, 0xb2, 0xb3, 0xfe, 0x00, 0x02, 0x03, 0x04, 0x05, 0x00, 0x06, 0x07,
          0x08, 0x09, 0x0c, 0x0a, 0x01, 0xfe, 0x00, 0x03, 0xb1, 0xb2, 0xb3, 0xfe, 0x00, 0x02, 0x03, 0x04, 0x05
        ],
        [0x91, 0x05, 0x02, 0x00, 0x06, 0x07, 0x08, 0x09, 0x0c, 0x0a, 0x01, 0xff, 0x00, 0x03],
        [0x92, 0x05]
      ]
    end

    context "with a speech model present" do
      let(:speech) do
        TimexDatalinkClient::Protocol7::Eeprom::Speech.new(
          device_nickname: [0xb1, 0xb1, 0xb1],
          user_nickname: [0xb2, 0xb2, 0xb2],
          phrases: [[0xb3], [0xb3], [0xb3]]
        )
      end

      it_behaves_like "CRC-wrapped packets", [
        [
          0x90, 0x05, 0x09, 0x44, 0x53, 0x49, 0x20, 0x54, 0x6f, 0x79, 0x73, 0x20, 0x70, 0x72, 0x65, 0x73, 0x65, 0x6e,
          0x74, 0x73, 0x2e, 0x2e, 0x2e, 0x65, 0x42, 0x72, 0x61, 0x69, 0x6e, 0x21, 0x00, 0x00, 0x00, 0x00, 0x00
        ],
        [
          0x91, 0x05, 0x01, 0x12, 0x00, 0x22, 0x00, 0x28, 0x00, 0x37, 0x00, 0x46, 0x00, 0x50, 0x00, 0x64, 0x00, 0x78,
          0x00, 0x87, 0x00, 0x96, 0x00, 0xa0, 0x00, 0xaf, 0x00, 0xbe, 0x00, 0xc8, 0x00, 0xd7, 0x00, 0xe1, 0x00
        ],
        [
          0x91, 0x05, 0x02, 0xeb, 0x00, 0xfa, 0x00, 0xff, 0x00, 0x04, 0x01, 0x03, 0xb1, 0xb1, 0xb1, 0x53, 0xc2, 0xfd,
          0x4d, 0x03, 0x8d, 0xc0, 0xfe, 0x00, 0x00, 0x00, 0x03, 0xb1, 0xb1, 0xb1, 0x53, 0xc2, 0xfd, 0x4d, 0x03
        ],
        [
          0x91, 0x05, 0x03, 0x7b, 0xc0, 0xfe, 0x00, 0x00, 0x00, 0x03, 0xb2, 0xb2, 0xb2, 0xfb, 0xc3, 0x63, 0x39, 0x3c,
          0xfe, 0x03, 0xb2, 0xb2, 0xb2, 0xfb, 0xc1, 0x61, 0x39, 0x3c, 0x94, 0xc1, 0xfd, 0x4b, 0x03, 0x44, 0xf0
        ],
        [
          0x91, 0x05, 0x04, 0x27, 0xfe, 0x00, 0x00, 0x03, 0xb2, 0xb2, 0xb2, 0xfb, 0x4c, 0xae, 0x30, 0x29, 0x3c, 0xcc,
          0xfb, 0x30, 0x20, 0x3c, 0x1c, 0x39, 0x24, 0xfe, 0x00, 0x03, 0xb2, 0xb2, 0xb2, 0xfb, 0xc6, 0x53, 0x03
        ],
        [
          0x91, 0x05, 0x05, 0xae, 0xe6, 0x70, 0x8e, 0xfe, 0x00, 0x00, 0x03, 0xb2, 0xb2, 0xb2, 0x61, 0x07, 0x39, 0x3c,
          0x44, 0xfd, 0x30, 0x4b, 0xfe, 0x00, 0x00, 0x03, 0xb2, 0xb2, 0xb2, 0xfb, 0xfc, 0x61, 0x3e, 0xfe, 0x00
        ],
        [
          0x91, 0x05, 0x06, 0x01, 0xb2, 0xb2, 0xb2, 0xcb, 0x07, 0x39, 0x3c, 0x44, 0xfd, 0x30, 0x4b, 0xfe, 0x00, 0x00,
          0x00, 0xb2, 0xb2, 0xb2, 0x39, 0xdc, 0x5a, 0xae, 0xfd, 0x4b, 0x7c, 0x8e, 0x81, 0xfe, 0x00, 0x00, 0xb2
        ],
        [
          0x91, 0x05, 0x07, 0xb2, 0xb2, 0x39, 0xff, 0x5a, 0x1c, 0x81, 0xfe, 0x03, 0xb1, 0xb1, 0xb1, 0x53, 0xc2, 0xfd,
          0x4d, 0x03, 0x8d, 0x0c, 0x7b, 0x94, 0xfe, 0x00, 0x01, 0xb1, 0xb1, 0xb1, 0xe0, 0x70, 0xab, 0xfe, 0x00
        ],
        [
          0x91, 0x05, 0x08, 0x00, 0x02, 0xb1, 0xb1, 0xb1, 0x53, 0xc7, 0xfd, 0x4d, 0x82, 0xfe, 0x03, 0xb1, 0xb1, 0xb1,
          0x53, 0xc3, 0xfd, 0x4d, 0x03, 0x57, 0x73, 0x0c, 0xfd, 0x4d, 0xff, 0x30, 0xb3, 0xfe, 0x00, 0x00, 0x30
        ],
        [0x91, 0x05, 0x09, 0xb3, 0xfe, 0x00, 0x00, 0x30, 0xb3, 0xff, 0x00, 0x00, 0x05],
        [0x92, 0x05]
      ]
    end
  end
end
