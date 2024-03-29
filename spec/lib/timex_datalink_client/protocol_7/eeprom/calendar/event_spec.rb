# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol7::Eeprom::Calendar::Event do
  let(:time) { Time.new(2022, 12, 15, 3, 30, 0) }
  let(:phrase) { [0x069] }

  let(:event) do
    described_class.new(
      time:,
      phrase:
    )
  end

  describe "#phrase" do
    subject(:phrase_value) { event.phrase }

    it { should eq([0x069]) }

    context "when phrase is [0x064]" do
      let(:phrase) { [0x064] }

      it { should eq([0x064]) }
    end
  end

  describe "#time_formatted" do
    let(:device_time) { Time.new(2022, 12, 10, 1, 30, 0) }

    subject(:phrase_value) { event.time_formatted(device_time) }

    it { should eq([0xca, 0x05]) }

    context "when device_time is 2022-12-10 15:28:15" do
      let(:device_time) { Time.new(2022, 12, 10, 15, 28, 15) }

      it { should eq([0xca, 0x05]) }
    end

    context "when time is 2022-12-10 15:28:15" do
      let(:time) { Time.new(2022, 12, 23, 18, 30, 20) }

      it { should eq([0x7e, 0x0f]) }
    end

    context "when time is 2021-12-10 15:28:15" do
      let(:time) { Time.utc(2021, 12, 23, 18, 30, 20) }

      it do
        expect { phrase_value }.to raise_error(
          ActiveModel::ValidationError,
          "Validation failed: Time 2021-12-23 18:30:20 UTC must be greater or equal to device time!"
        )
      end
    end
  end
end
