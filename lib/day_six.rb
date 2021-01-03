# frozen_string_literal: true

class Group
  def initialize(input)
    @input = input
  end

  def count
    @input.chars.to_set.delete("\n").length
  end

  def unanimous_count
    decisions_per_person = @input.split("\n").map(&:chars)

    unanimous_decisions = decisions_per_person.reduce(decisions_per_person[0].to_set) do |acc, person_decision|
      acc & person_decision.to_set
    end

    unanimous_decisions.size
  end
end
