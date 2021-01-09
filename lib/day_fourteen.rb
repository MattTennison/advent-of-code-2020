class MaskElement
  def values(c)
    raise "should be implemented in subclasses"
  end
end

class ReplacementMaskElement < MaskElement
  def initialize(replacement_value)
    @replacement_value = replacement_value
  end

  def values(c)
    [@replacement_value]
  end
end

class PassthroughMaskElement < MaskElement
  def values(c)
    [c]
  end
end

class FloatingMaskElement < MaskElement
  def values(c)
    [0, 1]
  end
end

class PartOneBitmaskFactory
  def bitmask_for_str(str)
    mask_elements = str.chars.map { |c| from_mask_char(c) }
    Bitmask.new(mask_elements)
  end

  private

  def from_mask_char(c)
    factory = Hash.new(PassthroughMaskElement.new)
    factory['0'] = ReplacementMaskElement.new('0')
    factory['1'] = ReplacementMaskElement.new('1')
    
    return factory[c]
  end
end

class PartTwoBitmaskFactory
  def bitmask_for_str(str)
    mask_elements = str.chars.map { |c| from_mask_char(c) }
    Bitmask.new(mask_elements)
  end

  private

  def from_mask_char(c)
    factory = Hash.new(FloatingMaskElement.new)
    factory['0'] = PassthroughMaskElement.new
    factory['1'] = ReplacementMaskElement.new('1')
    
    return factory[c]
  end
end

class Bitmask
  def initialize(mask_elements)
    @mask_elements = mask_elements
  end

  def singular_value(number)
    self.floating_values(number).first
  end

  def floating_values(number)
    floating_values = number
      .to_s(2)
      .rjust(@mask_elements.count, '0')
      .chars
      .each_with_index
      .map { |n, index| @mask_elements[index].values(n) }

    floating_values[0].product(*floating_values[1..-1])
      .map { |inner_array_of_strings| inner_array_of_strings.join("") }
      .map { |binary_str| binary_str.to_i(2) }
  end

  private

  def from_mask_char(c)
    factory = Hash.new(PassthroughMaskElement.new)
    factory['0'] = ReplacementMaskElement.new('0')
    factory['1'] = ReplacementMaskElement.new('1')
    
    return factory[c]
  end
end

class Operation
  def run(memory_hash:, bitmask:)
    {
      :memory_hash => memory_hash,
      :bitmask => bitmask
    }
  end
end

class BitmaskOperation < Operation
  def initialize(bitmask)
    @bitmask = bitmask
  end
    
  def run(memory_hash:, bitmask:)
    {
      :memory_hash => memory_hash,
      :bitmask => @bitmask
    }
  end
end

class MemoryOperation < Operation
  def initialize(memory_index, memory_value)
    @memory_index = memory_index
    @memory_value = memory_value
  end
    
  def run(memory_hash:, bitmask:)
    {
      :memory_hash => memory_hash.merge({ @memory_index => bitmask.singular_value(@memory_value) }),
      :bitmask => bitmask
    }
  end
end

class MemoryOperationVersionTwo < Operation
  def initialize(memory_index:, memory_value:)
    @memory_index = memory_index
    @memory_value = memory_value
  end
    
  def run(memory_hash:, bitmask:)
    memory_addresses_to_overwrite = bitmask.floating_values(@memory_index)
    new_entries = memory_addresses_to_overwrite.reduce(Hash.new) do |acc, memory_address|
      acc.merge({ memory_address => @memory_value })
    end
    {
      :memory_hash => memory_hash.merge(new_entries),
      :bitmask => bitmask
    }
  end
end

class DockingProgram
  def initialize(program_lines, bitmask_factory = PartOneBitmaskFactory.new)
    @operations = program_lines
      .split("\n")
      .map { |line| operation_for_line(line, bitmask_factory) }
  end

  def run
    starting_state = {
      :memory_hash => Hash.new,
      :bitmask => Bitmask.new("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
    }

    @operations
      .reduce(starting_state) { | state, line| line.run(state) }[:memory_hash]
      .values
      .sum
  end

  private

  def operation_for_line(line, bitmask_factory)
    bitmask_operation_regex = Regexp.new(/mask = ([10X]+)/)
    if (bitmask_operation_regex.match?(line))
      bitmask_str = bitmask_operation_regex.match(line).captures[0]
      bitmask = bitmask_factory.bitmask_for_str(bitmask_str)
      return BitmaskOperation.new(bitmask)
    end

    memory_operation_regex = Regexp.new(/mem\[(\d+)\] = (\d+)/)
    if (memory_operation_regex.match?(line))
      memory_index, memory_value = memory_operation_regex.match(line).captures
      return MemoryOperation.new(memory_index, memory_value.to_i)
    end
    
    return Operation.new
  end
end