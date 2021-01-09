require "day_fourteen"

RSpec.describe Bitmask do
  describe "Bitmask" do
    describe "#write" do
      where(:input, :expected_output) do
        [
          [11, 73],
          [101, 101],
          [0, 64]
        ]
      end

      with_them do
        it "returns the expected result" do
          bitmask = Bitmask.new("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X")

          output = bitmask.write(input)

          expect(output).to equal(expected_output)
        end
      end
    end
  end
end

RSpec.describe DockingProgram do
  describe "DockingProgram" do
    it "#run" do
      program = DockingProgram.new("
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0".strip)

      output = program.run

      expect(output).to equal(165)
    end
  end
end