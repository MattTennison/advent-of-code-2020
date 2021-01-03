# frozen_string_literal: true

class DayTwo
  def solve(arr)
    arr.count do |entry|
      minCharacterCount, maxCharacterCount, character, password = /(\d+)-(\d+) (\w): (\w+)/.match(entry).captures
      numberOfCharacterInPassword = password.count(character)
      numberOfCharacterInPassword.between?(minCharacterCount.to_i, maxCharacterCount.to_i)
    end
  end

  def solve_two(arr)
    arr.count do |entry|
      firstPosition, secondPosition, character, password = /(\d+)-(\d+) (\w): (\w+)/.match(entry).captures
      password[firstPosition.to_i - 1].eql?(character) ^ password[secondPosition.to_i - 1].eql?(character)
    end
  end
end
