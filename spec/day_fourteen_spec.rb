require "day_fourteen"

RSpec.describe Bitmask do
  describe "Bitmask" do
    describe "#singular_value" do
      where(:input, :expected_output) do
        [
          [11, 73],
          [101, 101],
          [0, 64]
        ]
      end

      with_them do
        it "returns the expected result" do
          factory = PartOneBitmaskFactory.new
          bitmask = factory.bitmask_for_str("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X")

          output = bitmask.singular_value(input)

          expect(output).to equal(expected_output)
        end
      end
    end
  end
end

RSpec.describe MemoryOperationVersionTwo do
  describe "MemoryOperationVersionTwo" do
    describe "#run" do
      where(:bitmask_str, :memory_index, :memory_value, :expected_overriden_memory_addresses) do
        [
          ["000000000000000000000000000000X1001X", 42, 100, [26, 27, 58, 59]],
          ["00000000000000000000000000000000X0XX", 26, 1, [16, 17, 18, 19, 24, 25, 26, 27]]
        ]
      end

      with_them do
        it "overwrites the right memory addresses" do
          factory = PartTwoBitmaskFactory.new
          bitmask = factory.bitmask_for_str(bitmask_str)
          starting_memory_hash = Hash.new
          operation = MemoryOperationVersionTwo.new(memory_index: memory_index, memory_value: memory_value)
  
          result = operation.run(bitmask: bitmask, memory_hash: starting_memory_hash)
          resulting_memory_hash = result[:memory_hash]

          expected_overriden_memory_addresses.each do |memory_address|
            expect(resulting_memory_hash[memory_address]).to equal(memory_value)
          end
        end
      end
    end
  end
end

RSpec.describe DockingProgram do
  describe "DockingProgram" do
    describe "#run" do
      it "returns expected answer for part one" do
        program = DockingProgram.new("
          mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
          mem[8] = 11
          mem[7] = 101
          mem[8] = 0".strip)
          
        output = program.run
  
        expect(output).to equal(165)
      end

      it "returns expected answer for part two" do
        input = "mask = 000000000000000000000000000000X1001X
        mem[42] = 100
        mask = 00000000000000000000000000000000X0XX
        mem[26] = 1".strip
        program = DockingProgram.new(input, PartTwoOperationFactory.new)
          
        output = program.run
  
        expect(output).to equal(208)
      end
    end
  end
end
