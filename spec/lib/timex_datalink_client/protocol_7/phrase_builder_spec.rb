# frozen_string_literal: true

require "spec_helper"

describe TimexDatalinkClient::Protocol7::PhraseBuilder do
  let(:phrase_builder) { described_class.new(database: "") }

  let(:vocab_results) do
    [
      { :"PC Index" => "292", :Label => "Cool" },
      { :"PC Index" => "1021", :Label => "<NoPause>" },
      { :"PC Index" => "74", :Label => "'est" },
      { :"PC Index" => "1233", :Label => "Coolest" },
      { :"PC Index" => "285", :Label => "Club" }
    ]
  end

  let(:vocab_links_results) do
    [
      { :"PC Index" => "292", :Sequence => "1", :"eBrain Index" => "292" },
      { :"PC Index" => "285", :Sequence => "1", :"eBrain Index" => "285" },
      { :"PC Index" => "1233", :Sequence => "1", :"eBrain Index" => "292" },
      { :"PC Index" => "1233", :Sequence => "2", :"eBrain Index" => "1021" },
      { :"PC Index" => "1233", :Sequence => "3", :"eBrain Index" => "74" }
    ]
  end

  let(:mdb_double) do
    double(:Mdb).tap do |mdb|
      allow(mdb).to receive(:[]).with("Vocab").and_return(vocab_results)
      allow(mdb).to receive(:[]).with("Vocab Links").and_return(vocab_links_results)
    end
  end

  before(:each) { allow(phrase_builder).to receive(:mdb).and_return(mdb_double) }

  describe "#vocab_ids_for" do
    subject(:vocab_ids_for) { phrase_builder.vocab_ids_for(*words) }

    context "when words is [\"cool\", \"club\"]" do
      let(:words) { ["cool", "club"] }

      it { should eq([0x124, 0x11d]) }
    end

    context "when words is [\"coolest\", \"club\"]" do
      let(:words) { ["coolest", "club"] }

      it { should eq([0x124, 0x3fd, 0x4a, 0x11d]) }
    end

    context "when words is [\"nostalgia\", \"club\"]" do
      let(:words) { ["nostalgia", "club"] }

      it { expect { vocab_ids_for }.to raise_error(described_class::WordNotFound, "nostalgia is not a valid word!") }
    end
  end
end
