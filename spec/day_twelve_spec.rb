require "day_twelve"

RSpec.describe FerryNavigationInstructionFactory do
  describe "FerryNavigationInstructionFactory" do
    all_zero_ferry_position = FerryPosition.new(x: 0, y: 0, direction_in_degrees_clockwise: 0)

    where(:instruction_input, :starting_ferry_position, :expected_ferry_position) do
      [
        ["N10", all_zero_ferry_position, FerryPosition.new(x: 0, y: 10, direction_in_degrees_clockwise: 0)],
        ["S10", all_zero_ferry_position, FerryPosition.new(x: 0, y: -10, direction_in_degrees_clockwise: 0)],
        ["E10", all_zero_ferry_position, FerryPosition.new(x: 10, y: 0, direction_in_degrees_clockwise: 0)],
        ["W10", all_zero_ferry_position, FerryPosition.new(x: -10, y: 0, direction_in_degrees_clockwise: 0)],
        ["R90", all_zero_ferry_position, FerryPosition.new(x: 0, y: 0, direction_in_degrees_clockwise: 90)],
        ["R450", all_zero_ferry_position, FerryPosition.new(x: 0, y: 0, direction_in_degrees_clockwise: 90)],
        ["L90", all_zero_ferry_position, FerryPosition.new(x: 0, y: 0, direction_in_degrees_clockwise: 270)],
        [
          "R180",
          FerryPosition.new(x: 0, y: 0, direction_in_degrees_clockwise: 270),
          FerryPosition.new(x: 0, y: 0, direction_in_degrees_clockwise: 90)
        ],
        [
          "L180",
          FerryPosition.new(x: 0, y: 0, direction_in_degrees_clockwise: 90),
          FerryPosition.new(x: 0, y: 0, direction_in_degrees_clockwise: 270)
        ],
        ["F10", all_zero_ferry_position, FerryPosition.new(x: 0, y: 10, direction_in_degrees_clockwise: 0)],
        [
          "F10",
          FerryPosition.new(x: 0, y: 0, direction_in_degrees_clockwise: 180),
          FerryPosition.new(x: 0, y: -10, direction_in_degrees_clockwise: 180)
        ],
        [
          "F10", 
          FerryPosition.new(x: 0, y: 0, direction_in_degrees_clockwise: 90),
          FerryPosition.new(x: 10, y: 0, direction_in_degrees_clockwise: 90)
        ],
        [
          "F10",
          FerryPosition.new(x: 0, y: 0, direction_in_degrees_clockwise: 270),
          FerryPosition.new(x: -10, y: 0, direction_in_degrees_clockwise: 270)
        ],
      ]
    end

    with_them do
      it "handles instructions as expected" do
        instruction = FerryNavigationInstructionFactory.from_input(instruction_input)
  
        new_position = instruction.translate(starting_ferry_position)
        
        expect(new_position.x).to equal(expected_ferry_position.x)
        expect(new_position.y).to equal(expected_ferry_position.y)
        expect(new_position.direction_in_degrees_clockwise).to equal(expected_ferry_position.direction_in_degrees_clockwise)
      end
    end
  end
end