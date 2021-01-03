# frozen_string_literal: true

class DayOne
  def solve(arr)
    lookup = Hash.new(false)

    arr.each { |x| lookup[x] = true }
    match = arr.find { |x| lookup[2020 - x] }

    match.nil? ? -1 : match * (2020 - match)
  end

  def solve_second(arr)
    arr.combination(3) do |combos|
      return combos[0] * combos[1] * combos[2] if combos.sum === 2020
    end
  end
end
