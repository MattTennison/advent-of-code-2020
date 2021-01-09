class MaskElement
  def singular(c)
    raise "should be implemented in subclasses"
  end

  def floating_values(c)
    [self.singular(c)]
  end
end

class ZeroMaskElement < MaskElement
  def singular(c)
    c
  end
end

class OneMaskElement < MaskElement
  def singular(c)
    '1'
  end
end

class PassthroughMaskElement < MaskElement
  def singular(c)
    c
  end

  def floating_values(c)
    ['0', '1']
  end
end

class FloatingMaskElement < MaskElement
  def values(c)
    [0, 1]
  end
end

class Bitmask
  def initialize(mask)
    @mask_str = mask
  end

  def singular_value(number)
    mask_elements = @mask_str.chars.map { |c| from_mask_char(c) }
    number
      .to_s(2)
      .rjust(mask_elements.count, '0')
      .chars
      .reverse
      .each_with_index
      .reduce("") { |acc, (n, index)| mask_elements.reverse[index].singular(n) + acc }
      .to_i(2)
  end

  def floating_values(number)
    mask_elements = @mask_str.chars.map { |c| from_mask_char(c) }
    floating_values = number
      .to_s(2)
      .rjust(mask_elements.count, '0')
      .chars
      .each_with_index
      .map { |n, index| mask_elements[index].floating_values(n) }

    floating_values[0].product(*floating_values[1..-1])
      .map { |inner_array_of_strings| inner_array_of_strings.join("") }
      .map { |binary_str| binary_str.to_i(2) }
  end

  private

  def from_mask_char(c)
    factory = Hash.new(PassthroughMaskElement.new)
    factory['0'] = ZeroMaskElement.new
    factory['1'] = OneMaskElement.new
    
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
  def initialize(bitmask_str)
    @bitmask_str = bitmask_str
  end
    
  def run(memory_hash:, bitmask:)
    {
      :memory_hash => memory_hash,
      :bitmask => Bitmask.new(@bitmask_str)
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
  def initialize(program_lines)
    @operations = program_lines
      .split("\n")
      .map { |line| operation_for_line(line) }
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

  def operation_for_line(line)
    bitmask_operation_regex = Regexp.new(/mask = ([10X]+)/)
    if (bitmask_operation_regex.match?(line))
      bitmask_str = bitmask_operation_regex.match(line).captures[0]
      return BitmaskOperation.new(bitmask_str)
    end

    memory_operation_regex = Regexp.new(/mem\[(\d+)\] = (\d+)/)
    if (memory_operation_regex.match?(line))
      memory_index, memory_value = memory_operation_regex.match(line).captures
      return MemoryOperation.new(memory_index, memory_value.to_i)
    end
    
    return Operation.new
  end
end