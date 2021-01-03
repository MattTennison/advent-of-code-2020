# frozen_string_literal: true

class DayTwo
  def solve(arr)
    arr.count do |entry|
      min_character_count, max_character_count, character, password = /(\d+)-(\d+) (\w): (\w+)/.match(entry).captures
      no_of_characters_in_password = password.count(character)
      no_of_characters_in_password.between?(min_character_count.to_i, max_character_count.to_i)
    end
  end

  def solve_two(arr)
    arr.count do |entry|
      first_position, second_position, character, password = /(\d+)-(\d+) (\w): (\w+)/.match(entry).captures
      password[first_position.to_i - 1].eql?(character) ^ password[second_position.to_i - 1].eql?(character)
    end
  end
end
