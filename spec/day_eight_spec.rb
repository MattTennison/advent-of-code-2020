require "day_eight"

RSpec.describe Boot do
  describe "Halting Problem" do
    instructions = [
      "nop +0",
      "acc +1",
      "jmp +4",
      "acc +3",
      "jmp -3",
      "acc -99",
      "acc +1",
      "jmp -4",
      "acc +6"
    ].map {|str| Instruction.new(str) }

    it "halts with the accumulator at 5" do
      boot = Boot.new(instructions)

      expect(boot.execute[:accumulator]).to eq(5)
    end
  end
end

RSpec.describe CorruptBootRepair do
  describe "Fix Instructions" do
    instructions = [
      "nop +0",
      "acc +1",
      "jmp +4",
      "acc +3",
      "jmp -3",
      "acc -99",
      "acc +1",
      "jmp -4",
      "acc +6"
    ].map {|str| Instruction.new(str) }

    it "should replace jmp -4 with nop -4" do
      boot_repair = CorruptBootRepair.new(instructions)

      valid_instructions = boot_repair.valid_instructions
      expect(valid_instructions.at(7)).to have_attributes(:operation => "nop", :argument => -4)
    end
  end
end
