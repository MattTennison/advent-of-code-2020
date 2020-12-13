class InvalidXmasInput < StandardError
  def initialize(msg)
    super
  end
end

class InvalidElementInXmasInput < InvalidXmasInput
  attr_reader :elem

  def initialize(elem)
    super("invalid.element")
    @elem = elem
  end
end

class XmasAlgorithm
  def self.validate(input, preamble_length)
    raise InvalidXmasInput.new("input.shorter.than.preamble") if input.count < preamble_length

    preamble = input.slice(0, preamble_length)

    input.each.with_index do |elem, index|
      is_preamble = index < preamble_length

      if (!is_preamble)
        is_valid = input
          .slice(index - preamble_length, preamble_length)
          .combination(2)
          .map{|combos| combos.sum}
          .include?(elem)
        raise InvalidElementInXmasInput.new(elem) if !is_valid
      end
    end

    true
  end

  def self.weakness(input, invalid_element)
    raise InvalidXmasInput.new("invalid.element.not.in.input") if !input.include?(invalid_element)

    weakness_range = input
      .map.with_index do |element, i|
        final_elem = i
        while (input.slice(i..final_elem).sum < invalid_element) 
          final_elem = final_elem + 1
        end
        
        is_match = element != invalid_element && input.slice(i..final_elem).sum == invalid_element
        is_match ? (i..final_elem) : nil
      end
      .compact
      .first
    
    return weakness_range != nil ? input.slice(weakness_range).min + input.slice(weakness_range).max : nil
  end
end