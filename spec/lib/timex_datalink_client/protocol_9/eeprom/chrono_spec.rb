# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol9::Eeprom::Chrono do
  let(:label) { "Chrono" }
  let(:laps) { 20 }

  let(:timer) do
    described_class.new(
      label: label,
      laps: laps
    )
  end

  describe "#packet", :crc do
    subject(:packet) { timer.packet }

    it { should eq([0x24, 0x0c, 0x11, 0x1b, 0x18, 0x17, 0x18, 0x24]) }

    context "when label is \"Chrono with More than 8 Characters\"" do
      let(:label) { "Wake Up with More than 8 Characters" }

      it { should eq([0x20, 0x0a, 0x14, 0x0e, 0x24, 0x1e, 0x19, 0x24]) }
    end

    context "when label is \";@_|<>[]\"" do
      let(:label) { ";@_|<>[]" }

      it { should eq([0x36, 0x38, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f]) }
    end

    context "when label is \"~with~invalid~characters\"" do
      let(:label) { "~with~invalid~characters" }

      it { should eq([0x24, 0x20, 0x12, 0x1d, 0x11, 0x24, 0x12, 0x17]) }
    end

    context "when label is \"a\"" do
      let(:label) { "a" }

      it { should eq([0x24, 0x24, 0x24, 0x0a, 0x24, 0x24, 0x24, 0x24]) }
    end

    context "when label is \"aa\"" do
      let(:label) { "aa" }

      it { should eq([0x24, 0x24, 0x24, 0x0a, 0x0a, 0x24, 0x24, 0x24]) }
    end

    context "when label is \"aaa\"" do
      let(:label) { "aaa" }

      it { should eq([0x24, 0x24, 0x0a, 0x0a, 0x0a, 0x24, 0x24, 0x24]) }
    end

    context "when laps is 5" do
      let(:laps) { 5 }

      it { should eq([0x24, 0x0c, 0x11, 0x1b, 0x18, 0x17, 0x18, 0x24]) }
    end
  end

  describe "#chrono_bytesize", :crc do
    subject(:chrono_bytesize) { timer.chrono_bytesize }

    it { should eq(94) }

    context "when laps is 2" do
      let(:laps) { 2 }

      it { should eq(22) }
    end

    context "when label is \"something else\"" do
      let(:label) { "something else" }

      it { should eq(94) }
    end
  end
end
