# frozen_string_literal: true

class DayThree
  def initialize(input)
    @input = input
  end

  def solve(right_delta_per_turn = 3, down_delta_per_turn = 1)
    grid = @input.split("\n").map do |row|
      row.chars.map { |char| char.eql?('#') }
    end

    rows_we_hit = grid.each_slice(down_delta_per_turn).map(&:first)

    has_hit_tree_on_row = rows_we_hit.map.with_index do |row, index|
      x = index * right_delta_per_turn
      row[x % row.count]
    end

    has_hit_tree_on_row.count(true)
  end
end
