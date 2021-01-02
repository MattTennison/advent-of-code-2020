require "day_twelve"

RSpec.describe ShipNavigationFactory do
  describe "ShipNavigationFactory" do
    all_zero_ship_position = Vector[0, 0]

    where(:instruction_input, :starting_ship_position, :expected_ship_position) do
      [
        ["N10", all_zero_ship_position, Vector[0, 10]],
        ["S10", all_zero_ship_position, Vector[0, -10]],
        ["E10", all_zero_ship_position, Vector[10, 0]],
        ["W10", all_zero_ship_position, Vector[-10, 0]],
      ]
    end

    with_them do
      it "handles instructions as expected" do
        instruction = ShipNavigationFactory.from_input(instruction_input)
  
        new_position = instruction.apply(
          ship_position: [0, 0], 
          waypoint_position: starting_ship_position
        )[:waypoint_position]

        expect(new_position[0]).to equal(expected_ship_position[0])
        expect(new_position[1]).to equal(expected_ship_position[1])
      end
    end
  end

  describe "ShipNavigationSystem" do
    where(:case_name, :instruction_str_arr, :expected_finishing_position) do
      [
        ["provided example", ["F10", "N3", "F7", "R90", "F11"], Vector[214, -72]],
        ["with a left turn", ["F10", "N3", "F7", "L90", "F11"], Vector[126, 148]],
        ["with a 180 degree turn", ["E3", "N4", "R180", "F5"], Vector[-65, -25]],
        ["with a 180 degree left turn", ["E3", "N4", "L180", "F5"], Vector[-65, -25]],
        ["with a 270 degree turn", ["E3", "N4", "R270", "F5"], Vector[-25, 65]],
        ["with a 0 degree turn", ["F10", "N3", "F7", "R90", "R0", "F11"], Vector[214, -72]]
      ]
    end

    with_them do
      it "#navigates" do
        nav_system = ShipNavigationSystem.new(instruction_str_arr)

        new_ship_position = nav_system.navigate
        
        expect(new_ship_position).to eq(expected_finishing_position)
      end
    end
  end
end