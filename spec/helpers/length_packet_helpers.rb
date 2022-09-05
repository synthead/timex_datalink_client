# frozen_string_literal: true

module LengthPacketHelpers
  def wrap_length_packet(packet)
    [packet.length + 1] + packet
  end

  shared_examples "a length-prefixed packet" do |packet|
    let(:length_packet) { wrap_length_packet(packet) }

    it { should eq(length_packet) }
  end
end
