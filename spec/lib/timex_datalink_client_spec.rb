# frozen_string_literal: true

require_relative "../../lib/timex_datalink_client.rb"

describe TimexDatalinkClient do
  describe "VERSION" do
    subject(:version) { described_class::VERSION }

    it { should eq("0.1.0") }
  end
end
