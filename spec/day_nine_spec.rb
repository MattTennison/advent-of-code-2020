# frozen_string_literal: true

require 'day_nine'

RSpec.describe XmasAlgorithm do
  describe '#validate' do
    it 'should throw an error if preamble length is less than input' do
      expect { XmasAlgorithm.validate([1, 2, 3], 10) }.to raise_error(InvalidXmasInput)
    end

    it 'should consider single input valid if it can be summed by two preambles' do
      preamble = [1, 2, 3, 4, 5]
      input = [6]

      result = XmasAlgorithm.validate(preamble + input, preamble.count)

      expect(result).to equal(true)
    end

    it 'should throw an error if single input cannot be summed by two preambles' do
      preamble = [1, 2, 3, 4, 5]
      input = [16]

      expect { XmasAlgorithm.validate(preamble + input, preamble.count) }.to raise_error { |error|
        expect(error).to be_a(InvalidElementInXmasInput)
        expect(error.elem).to equal(16)
      }
    end

    it 'should throw an error if one of multiple inputs cannot be summed by preceeding elements' do
      preamble = [35, 20, 15, 25, 47]
      input = [40, 62, 55, 65, 95, 102, 117, 150, 182, 127, 219, 299, 277, 309, 576]

      expect { XmasAlgorithm.validate(preamble + input, preamble.count) }.to raise_error { |error|
        expect(error).to be_a(InvalidElementInXmasInput)
        expect(error.elem).to equal(127)
      }
    end
  end

  describe '#weakness' do
    it 'should throw an error if the invalid element is not in the input' do
      expect { XmasAlgorithm.weakness([1, 2], 10) }.to raise_error(InvalidXmasInput)
    end

    it 'should return nil if the weakness cannot be worked out from the input' do
      input = [1, 2, 3, 4, 5, 100]
      invalid_element = 100

      result = XmasAlgorithm.weakness(input, invalid_element)

      expect(result).to equal(nil)
    end

    it 'should find 62 as the weakness from the AoC sample' do
      input = [35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182, 127, 219, 299, 277, 309, 576]
      invalid_element = 127

      result = XmasAlgorithm.weakness(input, invalid_element)

      expect(result).to equal(62)
    end
  end
end
