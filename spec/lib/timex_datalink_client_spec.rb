# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient do
  describe "VERSION" do
    subject(:version) { described_class::VERSION }

    it { should eq("0.1.0") }
  end
end
