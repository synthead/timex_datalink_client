# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol9::Sync do
  let(:length) { 200 }
  let(:sync) { described_class.new(length: length) }

  describe "#packets" do
    subject(:packets) { sync.packets }

    it { should eq([[0x55] * length + [0xaa] * 40]) }

    context "when length is 350" do
      let(:length) { 350 }

      it { should eq([[0x55] * length + [0xaa] * 40]) }
    end
  end
end
