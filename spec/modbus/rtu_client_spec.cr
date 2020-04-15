require "../spec_helper"

describe Modbus::RTUClient do
  describe "#read_coils" do
    it "should send and receive messages" do
      request = Bytes[0x02, 0x01, 0x00, 0x20, 0x00, 0x0C, 0x3D, 0xF6]
      response = Bytes[0x02, 0x01, 0x02, 0x80, 0x02, 0x1D, 0xFD]

      io = DuplexIO.new(IO::Memory.new(response))
      rtu_client = Modbus::RTUClient.new(io, 2)
      coils = rtu_client.read_coils(33, 12)

      bits = BitArray.new(12)
      bits[7] = true
      bits[9] = true
      coils.should eq bits

      io.tx.to_slice.should eq request
    end
  end

  describe "#read_input_registers" do
    it "should send and receive messages" do
      request = Bytes[0x01, 0x04, 0x00, 0xC8, 0x00, 0x02, 0xF0, 0x35]
      response = Bytes[0x01, 0x04, 0x04, 0x27, 0x10, 0xC3, 0x50, 0xA0, 0x39]

      io = DuplexIO.new(IO::Memory.new(response))
      rtu_client = Modbus::RTUClient.new(io)
      registers = rtu_client.read_input_registers(201, 2)

      registers.should eq [10000, 50000]
      io.tx.to_slice.should eq request
    end
  end
end
