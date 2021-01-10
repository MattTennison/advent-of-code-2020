class MemoryGame
  def initialize(initialisation_sequence)
    @sequence = initialisation_sequence

    @sequence_hash = initialisation_sequence.to_h {|number| [number, [initialisation_sequence.index(number)]]}
  end

  def number_at(index)
    return @sequence[index] if !@sequence[index].nil?

    (@sequence.count..index).each do |i|
      previous_number = @sequence[i - 1]

      indexes_of_previous_number = @sequence_hash[previous_number].reverse
      value = indexes_of_previous_number.one? ? 0 : indexes_of_previous_number[0] - indexes_of_previous_number[1]

      if @sequence_hash[value].nil?
        @sequence_hash[value] = []
      end

      @sequence_hash[value] = [@sequence_hash[value].last, i]
      @sequence.push(value)
    end

    @sequence.last
  end
end