# frozen_string_literal: true

class JoltageAdapterCollection
  def initialize(adapters)
    @adapters = adapters.sort
  end

  def chain
    links_in_chain = @adapters.each_cons(2)

    chain = links_in_chain.map do |adapters|
      input_adapter, output_adapter = adapters
      { input: input_adapter, output: output_adapter, difference_in_jolts: output_adapter - input_adapter }
    end

    chain.any? { |link| link[:difference_in_jolts] > 3 } ? nil : chain
  end

  def solve_advent_challenge
    chain = self.chain

    number_of_three_jolt_differences = chain.count { |link| link[:difference_in_jolts] == 3 }
    number_of_one_jolt_differences = chain.count { |link| link[:difference_in_jolts] == 1 }

    add_device(number_of_three_jolt_differences) * add_charging_outlet(number_of_one_jolt_differences)
  end

  def solve_second_advent_challenge
    chain = self.chain
    three_jolt_differences = chain.select { |link| link[:difference_in_jolts] == 3 }

    chunks_of_adapters = chain.each_with_object([[0]]) do |link, acc|
      acc.last.push(link[:input])
      acc.push([]) if three_jolt_differences.include?(link)
    end.reject { |chunk| chunk.eql?([]) }

    chunks_of_adapters.last.push(chain.last[:output])

    chunks_of_adapters
      .map { |chunk| get_combination(chunk) }
      .reduce(1) { |acc, chunks| acc * chunks.count }
  end

  private

  def get_combination(chunk)
    return [] unless is_valid_steps(chunk)

    return [chunk.first] if chunk.count == 1

    combinations = []
    inner_chunk = chunk.slice(1..chunk.count - 2)
    (0..chunk.count - 2).each do |number_of_items|
      inner_chunk
        .combination(number_of_items)
        .map { |combo| [chunk.first, combo, chunk.last].flatten }
        .select { |combo| is_valid_steps(combo)  }
        .each { |combo| combinations.push(combo) }
    end

    combinations
  end

  def is_valid_steps(chunk)
    chunk.each_cons(2).all? { |input, output| (output - input).between?(0, 3) }
  end

  def add_charging_outlet(number_of_one_jolt_differences)
    number_of_one_jolt_differences + 1
  end

  def add_device(number_of_three_jolt_differences)
    number_of_three_jolt_differences + 1
  end
end
