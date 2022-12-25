# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol9::Timer do
  let(:number) { 1 }
  let(:label) { "Timer 1" }
  let(:time) { Time.new(0, 1, 1, 1, 2, 3) }
  let(:action_at_end) { :stop_timer }

  let(:timer) do
    described_class.new(
      number:,
      label:,
      time:,
      action_at_end:
    )
  end

  describe "#packets", :crc do
    subject(:packets) { timer.packets }

    it_behaves_like "CRC-wrapped packets", [
      [0x43, 0x01, 0x01, 0x02, 0x03, 0x00, 0x1d, 0x12, 0x16, 0x0e, 0x1b, 0x24, 0x01, 0x24]
    ]

    context "when number is 2" do
      let(:number) { 2 }

      it_behaves_like "CRC-wrapped packets", [
        [0x43, 0x02, 0x01, 0x02, 0x03, 0x00, 0x1d, 0x12, 0x16, 0x0e, 0x1b, 0x24, 0x01, 0x24]
      ]
    end

    context "when label is \"Timer with More than 8 Characters\"" do
      let(:label) { "Wake Up with More than 8 Characters" }

      it_behaves_like "CRC-wrapped packets", [
        [0x43, 0x01, 0x01, 0x02, 0x03, 0x00, 0x20, 0x0a, 0x14, 0x0e, 0x24, 0x1e, 0x19, 0x24]
      ]
    end

    context "when label is \";@_|<>[]\"" do
      let(:label) { ";@_|<>[]" }

      it_behaves_like "CRC-wrapped packets", [
        [0x43, 0x01, 0x01, 0x02, 0x03, 0x00, 0x36, 0x38, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f]
      ]
    end

    context "when label is \"~with~invalid~characters\"" do
      let(:label) { "~with~invalid~characters" }

      it_behaves_like "CRC-wrapped packets", [
        [0x43, 0x01, 0x01, 0x02, 0x03, 0x00, 0x24, 0x20, 0x12, 0x1d, 0x11, 0x24, 0x12, 0x17]
      ]
    end

    context "when time is 16:35:12" do
      let(:time) { Time.new(0, 1, 1, 16, 35, 12) }

      it_behaves_like "CRC-wrapped packets", [
        [0x43, 0x01, 0x10, 0x23, 0x0c, 0x00, 0x1d, 0x12, 0x16, 0x0e, 0x1b, 0x24, 0x01, 0x24]
      ]
    end

    context "when action_at_end is :repeat_timer" do
      let(:action_at_end) { :repeat_timer }

      it_behaves_like "CRC-wrapped packets", [
        [0x43, 0x01, 0x01, 0x02, 0x03, 0x01, 0x1d, 0x12, 0x16, 0x0e, 0x1b, 0x24, 0x01, 0x24]
      ]
    end

    context "when action_at_end is :start_chrono" do
      let(:action_at_end) { :start_chrono }

      it_behaves_like "CRC-wrapped packets", [
        [0x43, 0x01, 0x01, 0x02, 0x03, 0x02, 0x1d, 0x12, 0x16, 0x0e, 0x1b, 0x24, 0x01, 0x24]
      ]
    end
  end
end
