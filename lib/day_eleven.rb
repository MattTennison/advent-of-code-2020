class Ferry
  def initialize(input)
    rows = input.split("\n")
    @seats = rows.map.with_index do |row, row_number|
      row.strip.chars.map.with_index do |column, column_number|
        is_seat = column.eql?("#") || column.eql?("L")
        if (is_seat)
          is_occupied = column.eql?("#")
          Seat.new(row_number, column_number, is_occupied)
        else 
          Floor.new(row_number, column_number)
        end
      end
    end
  end

  def iterate(seat_finding_strategy, seating_rules = [TooCrowdedSeatingRule.new, SpaciousSeatingRule.new])
    @seats = @seats.map do |row|
      row.map { |s| s.iterate(seat_finding_strategy, seating_rules) }
    end
  end

  def stabilise(seat_finding_strategy, seating_rules = [TooCrowdedSeatingRule.new, SpaciousSeatingRule.new])
    has_stabilised = false
    
    while (!has_stabilised)
      previous_seats = @seats.flatten
      iterate(seat_finding_strategy, seating_rules)
      has_stabilised = (previous_seats - @seats.flatten).empty?
    end
  end

  def occupied
    @seats.flatten.count { |s| s.occupied? }
  end

  def seat_at(row_number:, column_number:)
    return nil if row_number < 0 || column_number < 0

    row = @seats[row_number]

    return nil if row.eql?(nil)

    column = row[column_number]
  end
end

class Seat
  attr_accessor :row
  attr_accessor :column
  attr_accessor :occupied
  alias_method :occupied?, :occupied

  def initialize(row, column, occupied)
    @row = row
    @column = column
    @occupied = occupied
  end

  def iterate(seat_finding_strategy, seating_rules)
    matching_rule = seating_rules.find {|r| r.matches?(seat_finding_strategy, self)}
    return self if matching_rule == nil

    return Seat.new(@row, @column, matching_rule.new_seat_occupuncy)
  end
end

class Floor
  attr_accessor :row
  attr_accessor :column
  attr_accessor :occupied
  alias_method :occupied?, :occupied

  def initialize(row, column)
    @row = row
    @column = column
    @occupied = false
  end

  def iterate(plane, seat_finding_strategy)
    return self
  end
end

class ImmediateSeatFindingStrategy
  def initialize(ferry)
    @ferry = ferry
  end

  def find_adjacent_seats(seat)
    row = seat.row
    column = seat.column

    seat_top_left = @ferry.seat_at(row_number: row - 1, column_number: column - 1)
    seat_top = @ferry.seat_at(row_number: row - 1, column_number: column)
    seat_top_right = @ferry.seat_at(row_number: row - 1, column_number: column + 1)

    seat_to_left = @ferry.seat_at(row_number: row, column_number: column - 1)
    seat_to_right = @ferry.seat_at(row_number: row, column_number: column + 1)

    seat_behind_left = @ferry.seat_at(row_number: row + 1, column_number: column - 1)
    seat_behind = @ferry.seat_at(row_number: row + 1, column_number: column)
    seat_behind_right = @ferry.seat_at(row_number: row + 1, column_number: column + 1)

    return [seat_top_left, seat_top, seat_top_right, seat_to_left, seat_to_right, seat_behind_left, seat_behind, seat_behind_right].compact
  end
end

class VisibleSeatFindingStrategy
  def initialize(ferry)
    @ferry = ferry
  end

  def find_adjacent_seats(seat)
    row = seat.row
    column = seat.column

    seat_top_left = find_seat(row: row, row_delta: -1, column: column, column_delta: -1)
    seat_top = find_seat(row: row, row_delta: -1, column: column, column_delta: 0)
    seat_top_right = find_seat(row: row, row_delta: -1, column: column, column_delta: 1)

    seat_to_left = find_seat(row: row, row_delta: 0, column: column, column_delta: -1)
    seat_to_right = find_seat(row: row, row_delta: 0, column: column, column_delta: 1)

    seat_behind_left = find_seat(row: row, row_delta: 1, column: column, column_delta: -1)
    seat_behind = find_seat(row: row, row_delta: 1, column: column, column_delta: 0)
    seat_behind_right = find_seat(row: row, row_delta: 1, column: column, column_delta: 1)

    return [seat_top_left, seat_top, seat_top_right, seat_to_left, seat_to_right, seat_behind_left, seat_behind, seat_behind_right].compact
  end

  private

  def find_seat(row:, row_delta:, column:, column_delta:)
    target_row = row + row_delta
    target_column = column + column_delta
    seat = @ferry.seat_at(row_number: target_row, column_number: target_column)

    if (seat.is_a?(Seat) || seat.eql?(nil))
      return seat
    end

    return self.find_seat(row: target_row, row_delta: row_delta, column: target_column, column_delta: column_delta)
  end
end

class TooCrowdedSeatingRule
  def initialize(occupied_seat_limit = 3)
    @occupied_seat_limit = occupied_seat_limit
  end

  def matches?(seat_finding_strategy, seat)
    occupied_adjacent_seats = seat_finding_strategy.find_adjacent_seats(seat).count { |s| s.occupied? }
    return seat.occupied && occupied_adjacent_seats > @occupied_seat_limit
  end

  def new_seat_occupuncy
    return false
  end
end

class SpaciousSeatingRule
  def matches?(seat_finding_strategy, seat)
    occupied_adjacent_seats = seat_finding_strategy.find_adjacent_seats(seat).count { |s| s.occupied? }
    return !seat.occupied && occupied_adjacent_seats == 0
  end

  def new_seat_occupuncy
    return true
  end
end
