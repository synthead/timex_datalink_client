# frozen_string_literal: true

module CrcHelpers
  def wrap_crc_packets(packets)
    packets.map do |packet|
      crc_header(packet) + packet + crc_footer(packet)
    end
  end

  def crc_header(packet)
    [packet.length + 3]
  end

  def crc_footer(packet)
    crc_check = (crc_header(packet) + packet).pack("C*")
    crc = CRC.crc16_arc(crc_check)

    crc.divmod(256)
  end

  shared_examples "CRC-wrapped packets" do |packets|
    let(:crc_packets) { wrap_crc_packets(packets) }

    it { should eq(crc_packets) }
  end
end
