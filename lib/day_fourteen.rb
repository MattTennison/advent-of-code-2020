class MaskElement
  def with(c)
    raise "should be implemented in subclasses"
  end
end

class ZeroMaskElement < MaskElement
  def with(c)
    '0'
  end
end

class OneMaskElement < MaskElement
  def with(c)
    '1'
  end
end

class NullMaskElement < MaskElement
  def with(c)
    c
  end
end

class Bitmask
  def initialize(mask)
    @mask = mask.chars.map do |mask_element_str|
      case mask_element_str
      when '1'
        OneMaskElement.new
      when '0'
        ZeroMaskElement.new
      else
        NullMaskElement.new
      end
    end
  end

  def write(number)
    number
      .to_s(2)
      .rjust(@mask.count, '0')
      .chars
      .reverse
      .each_with_index
      .reduce("") { |acc, (n, index)| @mask.reverse[index].with(n) + acc }
      .to_i(2)
  end
end

# class BitmaskOperation
#   def initialize(str)
#     regex = Regexp.new(/mask = ([10X]+)/)
#     value = regex.match(str).captures[0]
#     @bitmask = Bitmask.new(value)
#   end

#   def run(memory_hash:, bitmask)
    
#   end
# end

class DockingProgram
  def initialize(program_lines)
    @program_lines = program_lines.split("\n")
  end

  def run
    bitmask = Bitmask.new("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
    memory = @program_lines.reduce(Hash.new) do |memory_hash, line|
      bitmask_operation_regex = Regexp.new(/mask = ([10X]+)/)
      memory_operation_regex = Regexp.new(/mem\[(\d+)\] = (\d+)/)

      if (bitmask_operation_regex.match?(line))
        value = bitmask_operation_regex.match(line).captures[0]
        bitmask = Bitmask.new(value)
        memory_hash
      elsif (memory_operation_regex.match?(line))
        memory_index, memory_value = memory_operation_regex.match(line).captures
        memory_hash.merge({ memory_index => bitmask.write(memory_value.to_i) })
      end
    end

    memory.values.sum
  end
end