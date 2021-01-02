require "matrix"

class ShipNavigationFactory
  def self.from_input(str)
    regex = Regexp.new(/([A-Z])(\d+)/)
    action, value = regex.match(str).captures
    
    case action
    when "N"
      return VectorWaypointNavigationInstruction.new(Vector[0, value.to_i])
    when "S"
      return VectorWaypointNavigationInstruction.new(Vector[0, -value.to_i])
    when "E"
      return VectorWaypointNavigationInstruction.new(Vector[value.to_i, 0])
    when "W"
      return VectorWaypointNavigationInstruction.new(Vector[-value.to_i, 0])
    when "R"
      return RotationalWaypointNavigationInstruction.new(value.to_i)
    when "L"
      return RotationalWaypointNavigationInstruction.new(-value.to_i)
    when "F"
      return ForwardShipNavigationInstruction.new(value.to_i)
    end
  end
end

class VectorWaypointNavigationInstruction
  def initialize(vector)
    @vector = vector
  end

  def apply(ship_position:, waypoint_position:)
    {
      ship_position: ship_position,
      waypoint_position: waypoint_position + @vector
    }
  end
end

class RotationalWaypointNavigationInstruction
  def initialize(value)
    @value = value
  end

  def apply(ship_position:, waypoint_position:)
    {
      ship_position: ship_position,
      waypoint_position: translate(waypoint_position)
    }
  end

  private

  def translate(waypoint_position)
    case @value % 360
    when 0
      waypoint_position
    when 90
      Matrix.columns([[0, -1], [1, 0]]) * waypoint_position
    when 180
      Matrix.columns([[-1, 0], [0, -1]]) * waypoint_position
    when 270
      Matrix.columns([[0, 1], [-1, 0]]) * waypoint_position
    end
  end
end

class ForwardShipNavigationInstruction
  def initialize(value)
    @value = value
  end

  def apply(ship_position:, waypoint_position:)
    delta = waypoint_position * @value
    {
      ship_position: ship_position + delta,
      waypoint_position: waypoint_position
    }
  end
end

class ShipNavigationSystem
  def initialize(instruction_str_arr)
    @instructions = instruction_str_arr.map { |instruction| ShipNavigationFactory.from_input(instruction) }
  end

  def navigate
    starting_position = { 
      ship_position: Vector[0, 0],
      waypoint_position: Vector[10, 1] 
    }

    finishing_position = @instructions.reduce(starting_position) do |positions, instruction|
      instruction.apply(positions)
    end

    finishing_position[:ship_position]
  end
end