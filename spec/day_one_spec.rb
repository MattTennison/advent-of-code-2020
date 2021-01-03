# frozen_string_literal: true

require 'day_one'

RSpec.describe DayOne do
  describe 'solve' do
    it 'returns a solution given array with two valid numbers' do
      expect(DayOne.new.solve([1721, 299])).to eq(514_579)
    end

    it 'returns -1 given array without two valid numbers' do
      expect(DayOne.new.solve([1, 2])).to eq(-1)
    end

    it 'returns a solution given longer array with two valid numbers' do
      expect(DayOne.new.solve([2, 1721, 299])).to eq(514_579)
    end
  end

  describe 'solve_second' do
    it 'returns a solution given array with three valid numbers' do
      expect(DayOne.new.solve_second([979, 366, 675])).to eq(241_861_950)
    end
  end
end
