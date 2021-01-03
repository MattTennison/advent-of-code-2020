# frozen_string_literal: true

class InvalidXmasInput < StandardError
end

class InvalidElementInXmasInput < InvalidXmasInput
  attr_reader :elem

  def initialize(elem)
    super('invalid.element')
    @elem = elem
  end
end

class XmasAlgorithm
  def self.validate(input, preamble_length)
    raise InvalidXmasInput, 'input.shorter.than.preamble' if input.count < preamble_length

    preamble = input.slice(0, preamble_length)

    input.each.with_index do |elem, index|
      is_preamble = index < preamble_length

      unless is_preamble
        is_valid = input
                   .slice(index - preamble_length, preamble_length)
                   .combination(2)
                   .map(&:sum)
                   .include?(elem)
        raise InvalidElementInXmasInput, elem unless is_valid
      end
    end

    true
  end

  def self.weakness(input, invalid_element)
    raise InvalidXmasInput, 'invalid.element.not.in.input' unless input.include?(invalid_element)

    weakness_range = input
                     .map.with_index do |element, i|
      final_elem = i
      final_elem += 1 while input.slice(i..final_elem).sum < invalid_element

      is_match = element != invalid_element && input.slice(i..final_elem).sum == invalid_element
      is_match ? (i..final_elem) : nil
    end
                     .compact
                     .first

    !weakness_range.nil? ? input.slice(weakness_range).min + input.slice(weakness_range).max : nil
  end
end
