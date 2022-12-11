# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol7::Eeprom::Speech do
  let(:device_nickname) { [] }
  let(:user_nickname) { [] }
  let(:phrases) { [] }

  let(:speech) do
    described_class.new(
      device_nickname: device_nickname,
      user_nickname: user_nickname,
      phrases: phrases
    )
  end

  describe "#packet" do
    subject(:packet) { speech.packet }

    it do
      should eq [
        0x0b, 0x00, 0x00, 0x00, 0x1a, 0x00, 0x24, 0x00, 0x2e, 0x00, 0x38, 0x00, 0x47, 0x00, 0x56, 0x00, 0x60, 0x00,
        0x6a, 0x00, 0x6f, 0x00, 0x79, 0x00, 0x83, 0x00, 0xf0, 0x53, 0xfd, 0x4d, 0x03, 0xb0, 0x8d, 0xfe, 0x00, 0x00,
        0xf0, 0x53, 0xfd, 0x4d, 0x03, 0xb0, 0x7b, 0xfe, 0x00, 0x00, 0xf0, 0xfb, 0x63, 0x39, 0x3c, 0xc0, 0xfe, 0x00,
        0x00, 0x00, 0xf0, 0xfb, 0x61, 0x39, 0x3c, 0x70, 0x94, 0xfd, 0x4b, 0x03, 0x7c, 0x44, 0x27, 0xfe, 0x00, 0xd3,
        0xfb, 0xae, 0x30, 0x29, 0x33, 0x3c, 0xfb, 0x30, 0x20, 0x07, 0x3c, 0x39, 0x24, 0xfe, 0xf1, 0xfb, 0x53, 0x03,
        0xae, 0x9c, 0xe6, 0x8e, 0xfe, 0x00, 0xc1, 0x61, 0x39, 0x3c, 0x44, 0xcc, 0xfd, 0x4b, 0xfe, 0x00, 0xff, 0xfb,
        0x61, 0x3e, 0xfe, 0x41, 0xcb, 0x39, 0x3c, 0x44, 0xcc, 0xfd, 0x4b, 0xfe, 0x00, 0x37, 0x39, 0x5a, 0xae, 0xfd,
        0x1f, 0x4b, 0x8e, 0x81, 0xfe, 0x3f, 0x39, 0x5a, 0x1c, 0x81, 0xc0, 0xff, 0x00, 0x00, 0x00, 0x05
      ]
    end

    context "when device_nickname is [0x1e2, 0x3fd, 0x04d, 0x326, 0x003, 0x2df, 0x24d, 0x0f1, 0x069]" do
      let(:device_nickname) { [0x1e2, 0x3fd, 0x04d, 0x326, 0x003, 0x2df, 0x24d, 0x0f1, 0x069] }

      it do
        should eq [
          0x0f, 0x00, 0x00, 0x00, 0x22, 0x00, 0x36, 0x00, 0x4a, 0x00, 0x54, 0x00, 0x63, 0x00, 0x72, 0x00, 0x7c, 0x00,
          0x86, 0x00, 0x8b, 0x00, 0x95, 0x00, 0x9f, 0x00, 0xa9, 0x00, 0xc2, 0x00, 0xd1, 0x00, 0xe5, 0x00, 0x73, 0xe2,
          0xfd, 0x4d, 0x26, 0x28, 0x03, 0xdf, 0x4d, 0xf1, 0x3c, 0x69, 0x53, 0xfd, 0x4d, 0x2c, 0x03, 0x8d, 0xfe, 0x00,
          0x73, 0xe2, 0xfd, 0x4d, 0x26, 0x28, 0x03, 0xdf, 0x4d, 0xf1, 0x3c, 0x69, 0x53, 0xfd, 0x4d, 0x2c, 0x03, 0x7b,
          0xfe, 0x00, 0xf0, 0xfb, 0x63, 0x39, 0x3c, 0xc0, 0xfe, 0x00, 0x00, 0x00, 0xf0, 0xfb, 0x61, 0x39, 0x3c, 0x70,
          0x94, 0xfd, 0x4b, 0x03, 0x7c, 0x44, 0x27, 0xfe, 0x00, 0xd3, 0xfb, 0xae, 0x30, 0x29, 0x33, 0x3c, 0xfb, 0x30,
          0x20, 0x07, 0x3c, 0x39, 0x24, 0xfe, 0xf1, 0xfb, 0x53, 0x03, 0xae, 0x9c, 0xe6, 0x8e, 0xfe, 0x00, 0xc1, 0x61,
          0x39, 0x3c, 0x44, 0xcc, 0xfd, 0x4b, 0xfe, 0x00, 0xff, 0xfb, 0x61, 0x3e, 0xfe, 0x41, 0xcb, 0x39, 0x3c, 0x44,
          0xcc, 0xfd, 0x4b, 0xfe, 0x00, 0x37, 0x39, 0x5a, 0xae, 0xfd, 0x1f, 0x4b, 0x8e, 0x81, 0xfe, 0x3f, 0x39, 0x5a,
          0x1c, 0x81, 0xc0, 0xfe, 0x00, 0x00, 0x00, 0x73, 0xe2, 0xfd, 0x4d, 0x26, 0x28, 0x03, 0xdf, 0x4d, 0xf1, 0x3c,
          0x69, 0x53, 0xfd, 0x4d, 0x20, 0x03, 0x8d, 0x7b, 0x94, 0xc0, 0xfe, 0x00, 0x00, 0x00, 0x73, 0xe2, 0xfd, 0x4d,
          0x26, 0x28, 0x03, 0xdf, 0x4d, 0xf1, 0x17, 0x69, 0xe0, 0xab, 0xfe, 0x73, 0xe2, 0xfd, 0x4d, 0x26, 0x28, 0x03,
          0xdf, 0x4d, 0xf1, 0x2c, 0x69, 0x53, 0xfd, 0x4d, 0x70, 0x82, 0xfe, 0x00, 0x00, 0x73, 0xe2, 0xfd, 0x4d, 0x26,
          0x28, 0x03, 0xdf, 0x4d, 0xf1, 0x3c, 0x69, 0x53, 0xfd, 0x4d, 0x37, 0x03, 0x57, 0x0c, 0xfd, 0x30, 0x4d, 0xff,
          0x00, 0x00, 0x05
        ]
      end
    end

    context "when user_nickname is [0x030, 0x29c, 0x0ce, 0x092, 0x26d, 0x24d, 0x02c, 0x3fd, 0x0f4]" do
      let(:user_nickname) { [0x030, 0x29c, 0x0ce, 0x092, 0x26d, 0x24d, 0x02c, 0x3fd, 0x0f4] }

      it do
        should eq [
          0x0b, 0x00, 0x00, 0x00, 0x1a, 0x00, 0x24, 0x00, 0x2e, 0x00, 0x42, 0x00, 0x5b, 0x00, 0x79, 0x00, 0x8d, 0x00,
          0xa1, 0x00, 0xb5, 0x00, 0xc9, 0x00, 0xe2, 0x00, 0xf0, 0x53, 0xfd, 0x4d, 0x03, 0xb0, 0x8d, 0xfe, 0x00, 0x00,
          0xf0, 0x53, 0xfd, 0x4d, 0x03, 0xb0, 0x7b, 0xfe, 0x00, 0x00, 0x20, 0x30, 0x9c, 0xce, 0x92, 0xa3, 0x6d, 0x4d,
          0x2c, 0xfd, 0x3c, 0xf4, 0xfb, 0x63, 0x39, 0x30, 0x3c, 0xfe, 0x00, 0x00, 0x20, 0x30, 0x9c, 0xce, 0x92, 0xa3,
          0x6d, 0x4d, 0x2c, 0xfd, 0x3c, 0xf4, 0xfb, 0x61, 0x39, 0x1c, 0x3c, 0x94, 0xfd, 0x4b, 0x1f, 0x03, 0x44, 0x27,
          0xfe, 0x20, 0x30, 0x9c, 0xce, 0x92, 0xa3, 0x6d, 0x4d, 0x2c, 0xfd, 0x34, 0xf4, 0xfb, 0xae, 0x30, 0xcc, 0x29,
          0x3c, 0xfb, 0x30, 0xc1, 0x20, 0x3c, 0x39, 0x24, 0xc0, 0xfe, 0x00, 0x00, 0x00, 0x20, 0x30, 0x9c, 0xce, 0x92,
          0xa3, 0x6d, 0x4d, 0x2c, 0xfd, 0x3c, 0xf4, 0xfb, 0x53, 0x03, 0x67, 0xae, 0xe6, 0x8e, 0xfe, 0x20, 0x30, 0x9c,
          0xce, 0x92, 0xa3, 0x6d, 0x4d, 0x2c, 0xfd, 0x30, 0xf4, 0x61, 0x39, 0x3c, 0x73, 0x44, 0xfd, 0x4b, 0xfe, 0x20,
          0x30, 0x9c, 0xce, 0x92, 0xa3, 0x6d, 0x4d, 0x2c, 0xfd, 0x3f, 0xf4, 0xfb, 0x61, 0x3e, 0xc0, 0xfe, 0x00, 0x00,
          0x00, 0x20, 0x30, 0x9c, 0xce, 0x92, 0xa3, 0x6d, 0x4d, 0x2c, 0xfd, 0x10, 0xf4, 0xcb, 0x39, 0x3c, 0x73, 0x44,
          0xfd, 0x4b, 0xfe, 0x20, 0x30, 0x9c, 0xce, 0x92, 0xa3, 0x6d, 0x4d, 0x2c, 0xfd, 0x0d, 0xf4, 0x39, 0x5a, 0xae,
          0xc7, 0xfd, 0x4b, 0x8e, 0x81, 0xc0, 0xfe, 0x00, 0x00, 0x00, 0x20, 0x30, 0x9c, 0xce, 0x92, 0xa3, 0x6d, 0x4d,
          0x2c, 0xfd, 0x0f, 0xf4, 0x39, 0x5a, 0x1c, 0xf0, 0x81, 0xff, 0x00, 0x00, 0x05
        ]
      end
    end

    context "when phrases is [[0x1a7, 0x275, 0x319, 0x02c, 0x3fd, 0x0f4]]" do
      let(:phrases) { [[0x1a7, 0x275, 0x319, 0x02c, 0x3fd, 0x0f4]] }

      it do
        should eq [
          0x0c, 0x00, 0x1a, 0x00, 0x1c, 0x00, 0x26, 0x00, 0x30, 0x00, 0x3a, 0x00, 0x49, 0x00, 0x58, 0x00, 0x62, 0x00,
          0x6c, 0x00, 0x71, 0x00, 0x7b, 0x00, 0x85, 0x00, 0x8f, 0x00, 0xf0, 0x53, 0xfd, 0x4d, 0x03, 0xb0, 0x8d, 0xfe,
          0x00, 0x00, 0xf0, 0x53, 0xfd, 0x4d, 0x03, 0xb0, 0x7b, 0xfe, 0x00, 0x00, 0xf0, 0xfb, 0x63, 0x39, 0x3c, 0xc0,
          0xfe, 0x00, 0x00, 0x00, 0xf0, 0xfb, 0x61, 0x39, 0x3c, 0x70, 0x94, 0xfd, 0x4b, 0x03, 0x7c, 0x44, 0x27, 0xfe,
          0x00, 0xd3, 0xfb, 0xae, 0x30, 0x29, 0x33, 0x3c, 0xfb, 0x30, 0x20, 0x07, 0x3c, 0x39, 0x24, 0xfe, 0xf1, 0xfb,
          0x53, 0x03, 0xae, 0x9c, 0xe6, 0x8e, 0xfe, 0x00, 0xc1, 0x61, 0x39, 0x3c, 0x44, 0xcc, 0xfd, 0x4b, 0xfe, 0x00,
          0xff, 0xfb, 0x61, 0x3e, 0xfe, 0x41, 0xcb, 0x39, 0x3c, 0x44, 0xcc, 0xfd, 0x4b, 0xfe, 0x00, 0x37, 0x39, 0x5a,
          0xae, 0xfd, 0x1f, 0x4b, 0x8e, 0x81, 0xfe, 0x3f, 0x39, 0x5a, 0x1c, 0x81, 0xc0, 0xff, 0x00, 0x00, 0x00, 0x6c,
          0xa7, 0x75, 0x19, 0x2c, 0xcc, 0xfd, 0xf4, 0xff, 0x00, 0x05
        ]
      end
    end

    context "when phrases is [[0x069, 0x062], [0x016, 0x00a]]" do
      let(:phrases) { [[0x069, 0x062], [0x016, 0x00a]] }

      it do
        should eq [
          0x0d, 0x00, 0x1a, 0x00, 0x1e, 0x00, 0x28, 0x00, 0x32, 0x00, 0x3c, 0x00, 0x4b, 0x00, 0x5a, 0x00, 0x64, 0x00,
          0x6e, 0x00, 0x73, 0x00, 0x7d, 0x00, 0x87, 0x00, 0x91, 0x00, 0x96, 0x00, 0xf0, 0x53, 0xfd, 0x4d, 0x03, 0xb0,
          0x8d, 0xfe, 0x00, 0x00, 0xf0, 0x53, 0xfd, 0x4d, 0x03, 0xb0, 0x7b, 0xfe, 0x00, 0x00, 0xf0, 0xfb, 0x63, 0x39,
          0x3c, 0xc0, 0xfe, 0x00, 0x00, 0x00, 0xf0, 0xfb, 0x61, 0x39, 0x3c, 0x70, 0x94, 0xfd, 0x4b, 0x03, 0x7c, 0x44,
          0x27, 0xfe, 0x00, 0xd3, 0xfb, 0xae, 0x30, 0x29, 0x33, 0x3c, 0xfb, 0x30, 0x20, 0x07, 0x3c, 0x39, 0x24, 0xfe,
          0xf1, 0xfb, 0x53, 0x03, 0xae, 0x9c, 0xe6, 0x8e, 0xfe, 0x00, 0xc1, 0x61, 0x39, 0x3c, 0x44, 0xcc, 0xfd, 0x4b,
          0xfe, 0x00, 0xff, 0xfb, 0x61, 0x3e, 0xfe, 0x41, 0xcb, 0x39, 0x3c, 0x44, 0xcc, 0xfd, 0x4b, 0xfe, 0x00, 0x37,
          0x39, 0x5a, 0xae, 0xfd, 0x1f, 0x4b, 0x8e, 0x81, 0xfe, 0x3f, 0x39, 0x5a, 0x1c, 0x81, 0xc0, 0xff, 0x00, 0x00,
          0x00, 0x0c, 0x69, 0x62, 0xfe, 0x00, 0x0c, 0x16, 0x0a, 0xff, 0x00, 0x05
        ]
      end
    end

    context "when phrases is [[0x24d, 0x08e, 0x1e0, 0x26d, 0x09f], [0x069, 0x062]]" do
      let(:phrases) { [[0x24d, 0x08e, 0x1e0, 0x26d, 0x09f], [0x069, 0x062]] }

      it do
        should eq [
          0x0d, 0x00, 0x1a, 0x00, 0x1e, 0x00, 0x28, 0x00, 0x32, 0x00, 0x3c, 0x00, 0x4b, 0x00, 0x5a, 0x00, 0x64, 0x00,
          0x6e, 0x00, 0x73, 0x00, 0x7d, 0x00, 0x87, 0x00, 0x91, 0x00, 0x9b, 0x00, 0xf0, 0x53, 0xfd, 0x4d, 0x03, 0xb0,
          0x8d, 0xfe, 0x00, 0x00, 0xf0, 0x53, 0xfd, 0x4d, 0x03, 0xb0, 0x7b, 0xfe, 0x00, 0x00, 0xf0, 0xfb, 0x63, 0x39,
          0x3c, 0xc0, 0xfe, 0x00, 0x00, 0x00, 0xf0, 0xfb, 0x61, 0x39, 0x3c, 0x70, 0x94, 0xfd, 0x4b, 0x03, 0x7c, 0x44,
          0x27, 0xfe, 0x00, 0xd3, 0xfb, 0xae, 0x30, 0x29, 0x33, 0x3c, 0xfb, 0x30, 0x20, 0x07, 0x3c, 0x39, 0x24, 0xfe,
          0xf1, 0xfb, 0x53, 0x03, 0xae, 0x9c, 0xe6, 0x8e, 0xfe, 0x00, 0xc1, 0x61, 0x39, 0x3c, 0x44, 0xcc, 0xfd, 0x4b,
          0xfe, 0x00, 0xff, 0xfb, 0x61, 0x3e, 0xfe, 0x41, 0xcb, 0x39, 0x3c, 0x44, 0xcc, 0xfd, 0x4b, 0xfe, 0x00, 0x37,
          0x39, 0x5a, 0xae, 0xfd, 0x1f, 0x4b, 0x8e, 0x81, 0xfe, 0x3f, 0x39, 0x5a, 0x1c, 0x81, 0xc0, 0xff, 0x00, 0x00,
          0x00, 0x86, 0x4d, 0x8e, 0xe0, 0x6d, 0x30, 0x9f, 0xfe, 0x00, 0x00, 0x0c, 0x69, 0x62, 0xff, 0x00, 0x05
        ]
      end
    end

    context "when device_nickname, user_nickname, and one phrase are present" do
      let(:device_nickname) { [0x1e2, 0x3fd, 0x04d, 0x326, 0x003, 0x2df, 0x24d, 0x0f1, 0x069] }
      let(:user_nickname) { [0x030, 0x29c, 0x0ce, 0x092, 0x26d, 0x24d, 0x02c, 0x3fd, 0x0f4] }
      let(:phrases) { [[0x1a7, 0x275, 0x319, 0x02c, 0x3fd, 0x0f4]] }

      it do
        should eq [
          0x10, 0x00, 0x22, 0x00, 0x24, 0x00, 0x38, 0x00, 0x4c, 0x00, 0x60, 0x00, 0x79, 0x00, 0x97, 0x00, 0xab, 0x00,
          0xbf, 0x00, 0xd3, 0x00, 0xe7, 0x00, 0x00, 0x01, 0x14, 0x01, 0x2d, 0x01, 0x3c, 0x01, 0x50, 0x01, 0x69, 0x01,
          0x73, 0xe2, 0xfd, 0x4d, 0x26, 0x28, 0x03, 0xdf, 0x4d, 0xf1, 0x3c, 0x69, 0x53, 0xfd, 0x4d, 0x2c, 0x03, 0x8d,
          0xfe, 0x00, 0x73, 0xe2, 0xfd, 0x4d, 0x26, 0x28, 0x03, 0xdf, 0x4d, 0xf1, 0x3c, 0x69, 0x53, 0xfd, 0x4d, 0x2c,
          0x03, 0x7b, 0xfe, 0x00, 0x20, 0x30, 0x9c, 0xce, 0x92, 0xa3, 0x6d, 0x4d, 0x2c, 0xfd, 0x3c, 0xf4, 0xfb, 0x63,
          0x39, 0x30, 0x3c, 0xfe, 0x00, 0x00, 0x20, 0x30, 0x9c, 0xce, 0x92, 0xa3, 0x6d, 0x4d, 0x2c, 0xfd, 0x3c, 0xf4,
          0xfb, 0x61, 0x39, 0x1c, 0x3c, 0x94, 0xfd, 0x4b, 0x1f, 0x03, 0x44, 0x27, 0xfe, 0x20, 0x30, 0x9c, 0xce, 0x92,
          0xa3, 0x6d, 0x4d, 0x2c, 0xfd, 0x34, 0xf4, 0xfb, 0xae, 0x30, 0xcc, 0x29, 0x3c, 0xfb, 0x30, 0xc1, 0x20, 0x3c,
          0x39, 0x24, 0xc0, 0xfe, 0x00, 0x00, 0x00, 0x20, 0x30, 0x9c, 0xce, 0x92, 0xa3, 0x6d, 0x4d, 0x2c, 0xfd, 0x3c,
          0xf4, 0xfb, 0x53, 0x03, 0x67, 0xae, 0xe6, 0x8e, 0xfe, 0x20, 0x30, 0x9c, 0xce, 0x92, 0xa3, 0x6d, 0x4d, 0x2c,
          0xfd, 0x30, 0xf4, 0x61, 0x39, 0x3c, 0x73, 0x44, 0xfd, 0x4b, 0xfe, 0x20, 0x30, 0x9c, 0xce, 0x92, 0xa3, 0x6d,
          0x4d, 0x2c, 0xfd, 0x3f, 0xf4, 0xfb, 0x61, 0x3e, 0xc0, 0xfe, 0x00, 0x00, 0x00, 0x20, 0x30, 0x9c, 0xce, 0x92,
          0xa3, 0x6d, 0x4d, 0x2c, 0xfd, 0x10, 0xf4, 0xcb, 0x39, 0x3c, 0x73, 0x44, 0xfd, 0x4b, 0xfe, 0x20, 0x30, 0x9c,
          0xce, 0x92, 0xa3, 0x6d, 0x4d, 0x2c, 0xfd, 0x0d, 0xf4, 0x39, 0x5a, 0xae, 0xc7, 0xfd, 0x4b, 0x8e, 0x81, 0xc0,
          0xfe, 0x00, 0x00, 0x00, 0x20, 0x30, 0x9c, 0xce, 0x92, 0xa3, 0x6d, 0x4d, 0x2c, 0xfd, 0x0f, 0xf4, 0x39, 0x5a,
          0x1c, 0xf0, 0x81, 0xfe, 0x00, 0x00, 0x73, 0xe2, 0xfd, 0x4d, 0x26, 0x28, 0x03, 0xdf, 0x4d, 0xf1, 0x3c, 0x69,
          0x53, 0xfd, 0x4d, 0x20, 0x03, 0x8d, 0x7b, 0x94, 0xc0, 0xfe, 0x00, 0x00, 0x00, 0x73, 0xe2, 0xfd, 0x4d, 0x26,
          0x28, 0x03, 0xdf, 0x4d, 0xf1, 0x17, 0x69, 0xe0, 0xab, 0xfe, 0x73, 0xe2, 0xfd, 0x4d, 0x26, 0x28, 0x03, 0xdf,
          0x4d, 0xf1, 0x2c, 0x69, 0x53, 0xfd, 0x4d, 0x70, 0x82, 0xfe, 0x00, 0x00, 0x73, 0xe2, 0xfd, 0x4d, 0x26, 0x28,
          0x03, 0xdf, 0x4d, 0xf1, 0x3c, 0x69, 0x53, 0xfd, 0x4d, 0x37, 0x03, 0x57, 0x0c, 0xfd, 0x30, 0x4d, 0xff, 0x00,
          0x00, 0x6c, 0xa7, 0x75, 0x19, 0x2c, 0xcc, 0xfd, 0xf4, 0xff, 0x00, 0x05
        ]
      end
    end

    context "when device_nickname, user_nickname, and two phrases are present" do
      let(:device_nickname) { [0x1e2, 0x3fd, 0x04d, 0x326, 0x003, 0x2df, 0x24d, 0x0f1, 0x069] }
      let(:user_nickname) { [0x030, 0x29c, 0x0ce, 0x092, 0x26d, 0x24d, 0x02c, 0x3fd, 0x0f4] }
      let(:phrases) { [[0x1a7, 0x275, 0x319, 0x02c, 0x3fd, 0x0f4], [0x24d, 0x08e, 0x1e0, 0x26d, 0x09f]] }

      it do
        should eq [
          0x11, 0x00, 0x22, 0x00, 0x26, 0x00, 0x3a, 0x00, 0x4e, 0x00, 0x62, 0x00, 0x7b, 0x00, 0x99, 0x00, 0xad, 0x00,
          0xc1, 0x00, 0xd5, 0x00, 0xe9, 0x00, 0x02, 0x01, 0x16, 0x01, 0x2f, 0x01, 0x3e, 0x01, 0x52, 0x01, 0x6b, 0x01,
          0x75, 0x01, 0x73, 0xe2, 0xfd, 0x4d, 0x26, 0x28, 0x03, 0xdf, 0x4d, 0xf1, 0x3c, 0x69, 0x53, 0xfd, 0x4d, 0x2c,
          0x03, 0x8d, 0xfe, 0x00, 0x73, 0xe2, 0xfd, 0x4d, 0x26, 0x28, 0x03, 0xdf, 0x4d, 0xf1, 0x3c, 0x69, 0x53, 0xfd,
          0x4d, 0x2c, 0x03, 0x7b, 0xfe, 0x00, 0x20, 0x30, 0x9c, 0xce, 0x92, 0xa3, 0x6d, 0x4d, 0x2c, 0xfd, 0x3c, 0xf4,
          0xfb, 0x63, 0x39, 0x30, 0x3c, 0xfe, 0x00, 0x00, 0x20, 0x30, 0x9c, 0xce, 0x92, 0xa3, 0x6d, 0x4d, 0x2c, 0xfd,
          0x3c, 0xf4, 0xfb, 0x61, 0x39, 0x1c, 0x3c, 0x94, 0xfd, 0x4b, 0x1f, 0x03, 0x44, 0x27, 0xfe, 0x20, 0x30, 0x9c,
          0xce, 0x92, 0xa3, 0x6d, 0x4d, 0x2c, 0xfd, 0x34, 0xf4, 0xfb, 0xae, 0x30, 0xcc, 0x29, 0x3c, 0xfb, 0x30, 0xc1,
          0x20, 0x3c, 0x39, 0x24, 0xc0, 0xfe, 0x00, 0x00, 0x00, 0x20, 0x30, 0x9c, 0xce, 0x92, 0xa3, 0x6d, 0x4d, 0x2c,
          0xfd, 0x3c, 0xf4, 0xfb, 0x53, 0x03, 0x67, 0xae, 0xe6, 0x8e, 0xfe, 0x20, 0x30, 0x9c, 0xce, 0x92, 0xa3, 0x6d,
          0x4d, 0x2c, 0xfd, 0x30, 0xf4, 0x61, 0x39, 0x3c, 0x73, 0x44, 0xfd, 0x4b, 0xfe, 0x20, 0x30, 0x9c, 0xce, 0x92,
          0xa3, 0x6d, 0x4d, 0x2c, 0xfd, 0x3f, 0xf4, 0xfb, 0x61, 0x3e, 0xc0, 0xfe, 0x00, 0x00, 0x00, 0x20, 0x30, 0x9c,
          0xce, 0x92, 0xa3, 0x6d, 0x4d, 0x2c, 0xfd, 0x10, 0xf4, 0xcb, 0x39, 0x3c, 0x73, 0x44, 0xfd, 0x4b, 0xfe, 0x20,
          0x30, 0x9c, 0xce, 0x92, 0xa3, 0x6d, 0x4d, 0x2c, 0xfd, 0x0d, 0xf4, 0x39, 0x5a, 0xae, 0xc7, 0xfd, 0x4b, 0x8e,
          0x81, 0xc0, 0xfe, 0x00, 0x00, 0x00, 0x20, 0x30, 0x9c, 0xce, 0x92, 0xa3, 0x6d, 0x4d, 0x2c, 0xfd, 0x0f, 0xf4,
          0x39, 0x5a, 0x1c, 0xf0, 0x81, 0xfe, 0x00, 0x00, 0x73, 0xe2, 0xfd, 0x4d, 0x26, 0x28, 0x03, 0xdf, 0x4d, 0xf1,
          0x3c, 0x69, 0x53, 0xfd, 0x4d, 0x20, 0x03, 0x8d, 0x7b, 0x94, 0xc0, 0xfe, 0x00, 0x00, 0x00, 0x73, 0xe2, 0xfd,
          0x4d, 0x26, 0x28, 0x03, 0xdf, 0x4d, 0xf1, 0x17, 0x69, 0xe0, 0xab, 0xfe, 0x73, 0xe2, 0xfd, 0x4d, 0x26, 0x28,
          0x03, 0xdf, 0x4d, 0xf1, 0x2c, 0x69, 0x53, 0xfd, 0x4d, 0x70, 0x82, 0xfe, 0x00, 0x00, 0x73, 0xe2, 0xfd, 0x4d,
          0x26, 0x28, 0x03, 0xdf, 0x4d, 0xf1, 0x3c, 0x69, 0x53, 0xfd, 0x4d, 0x37, 0x03, 0x57, 0x0c, 0xfd, 0x30, 0x4d,
          0xff, 0x00, 0x00, 0x6c, 0xa7, 0x75, 0x19, 0x2c, 0xcc, 0xfd, 0xf4, 0xfe, 0x00, 0x86, 0x4d, 0x8e, 0xe0, 0x6d,
          0x30, 0x9f, 0xff, 0x00, 0x00, 0x05
        ]
      end
    end
  end
end
