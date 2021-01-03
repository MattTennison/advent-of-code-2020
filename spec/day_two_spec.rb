# frozen_string_literal: true

require 'day_two'

RSpec.describe DayTwo do
  describe 'solve' do
    it 'returns 1 given one valid password' do
      input = ['1-3 a: abcde', '1-3 b: cdefg']
      expect(DayTwo.new.solve(input)).to eq(1)
    end

    it 'returns 2 given two valid passwords' do
      input = ['1-3 a: abcde', '1-3 b: cdefg', '2-9 c: ccccccccc']
      expect(DayTwo.new.solve(input)).to eq(2)
    end

    it 'handles very large passwords' do
      input = ['1-3 a: abcde', '1-3 b: cdefg', '2-11 c: ccccccccccc']
      expect(DayTwo.new.solve(input)).to eq(2)
    end
  end

  describe 'solve_two' do
    it 'returns 1 given one valid password' do
      input = ['1-3 a: abcde', '1-3 b: cdefg', '2-9 c: ccccccccc']
      expect(DayTwo.new.solve_two(input)).to eq(1)
    end

    it 'returns 2 given two valid passwords' do
      input = ['1-3 a: abcde', '1-3 b: cdefg', '2-9 c: cdccccccc']
      expect(DayTwo.new.solve_two(input)).to eq(2)
    end
  end
end
