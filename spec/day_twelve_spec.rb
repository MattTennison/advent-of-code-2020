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
    it "navigates the ship to 214E, 72S for the sample input" do
      instruction_str_arr = ["F10", "N3", "F7", "R90", "F11"]
      nav_system = ShipNavigationSystem.new(instruction_str_arr)

      ship_position = nav_system.navigate

      expect(ship_position[0]).to equal(214)
      expect(ship_position[1]).to equal(-72)
    end

    it "handles left turns" do
      instruction_str_arr = ["F10", "N3", "F7", "L90", "F11"]
      nav_system = ShipNavigationSystem.new(instruction_str_arr)

      ship_position = nav_system.navigate

      expect(ship_position[0]).to equal(126)
      expect(ship_position[1]).to equal(148)
    end

    it "handles 180 degree turns" do
      instruction_str_arr = ["E3", "N4", "R180", "F5"] # (X: -13, Y: -5) * 5
      nav_system = ShipNavigationSystem.new(instruction_str_arr)

      ship_position = nav_system.navigate

      expect(ship_position[0]).to equal(-13 * 5)
      expect(ship_position[1]).to equal(-5 * 5)
    end

    it "handles 270 degree turns" do
      instruction_str_arr = ["E3", "N4", "R270", "F5"] # (X: 13, Y: 5) R270, 
      nav_system = ShipNavigationSystem.new(instruction_str_arr)

      ship_position = nav_system.navigate

      expect(ship_position[0]).to equal(-5 * 5)
      expect(ship_position[1]).to equal(13 * 5)
    end

    it "ignores 0 degree turns" do
      instruction_str_arr = ["E3", "N4", "R0", "F5"] # (X: 13, Y: 5) R270, 
      nav_system = ShipNavigationSystem.new(instruction_str_arr)

      ship_position = nav_system.navigate

      expect(ship_position[0]).to equal(13 * 5)
      expect(ship_position[1]).to equal(5 * 5)
    end
  end
end