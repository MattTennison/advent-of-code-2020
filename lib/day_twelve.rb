class FerryNavigationInstructionFactory
  def self.from_input(str)
    regex = Regexp.new(/([A-Z])(\d+)/)
    action, value = regex.match(str).captures
    
    case action
    when "N"
      return VerticalFerryNavigationInstruction.new(value.to_i)
    when "S"
      return VerticalFerryNavigationInstruction.new(-value.to_i)
    when "E"
      return HorizontalFerryNavigationInstruction.new(value.to_i)
    when "W"
      return HorizontalFerryNavigationInstruction.new(-value.to_i)
    when "R"
      return RotationalFerryNavigationInstruction.new(value.to_i)
    when "L"
      return RotationalFerryNavigationInstruction.new(-value.to_i)
    when "F"
      return ForwardFerryNavigationInstruction.new(value.to_i)
    end
  end
end

class VerticalFerryNavigationInstruction
  def initialize(value)
    @value = value
  end

  def translate(ferry_position)
    return ferry_position.translate(y: ferry_position.y + @value)
  end
end

class HorizontalFerryNavigationInstruction
  def initialize(value)
    @value = value
  end

  def translate(ferry_position)
    return ferry_position.translate(x: ferry_position.x + @value)
  end
end

class RotationalFerryNavigationInstruction
  def initialize(value)
    @value = value
  end

  def translate(ferry_position)
    new_degree = (ferry_position.direction_in_degrees_clockwise + @value) % 360

    return ferry_position.translate(direction_in_degrees_clockwise: new_degree)
  end
end

class ForwardFerryNavigationInstruction
  def initialize(value)
    @value = value
  end

  def translate(ferry_position)
    str = action(ferry_position) + @value.to_s
    instruction = FerryNavigationInstructionFactory.from_input(str)

    instruction.translate(ferry_position)
  end

  private

  def action(ferry_position)
    {
      0 => "N",
      90 => "E",
      180 => "S",
      270 => "W"
    }[ferry_position.direction_in_degrees_clockwise]
  end
end

class FerryPosition
  attr_accessor :x
  attr_accessor :y
  attr_accessor :direction_in_degrees_clockwise

  def initialize(x:, y:, direction_in_degrees_clockwise:)
    @x = x
    @y = y
    @direction_in_degrees_clockwise = direction_in_degrees_clockwise    
  end

  def translate(x: @x, y: @y, direction_in_degrees_clockwise: @direction_in_degrees_clockwise)
    FerryPosition.new(x: x, y: y, direction_in_degrees_clockwise: direction_in_degrees_clockwise)
  end
end