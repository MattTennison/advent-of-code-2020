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

  def iterate

    @seats = @seats.map do |row|
      row.map { |s| s.iterate(self) }
    end
  end

  def stabilise
    has_stabilised = false
    
    while (!has_stabilised)
      previous_seats = @seats.flatten
      iterate()
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
  def initialize(row, column, occupied)
    @row = row
    @column = column
    @occupied = occupied
  end

  def occupied?
    @occupied
  end

  def iterate(plane)
    occupied_adjacent_seats = adjacent_seats(plane).count { |s| s.occupied? }

    should_empty_seat = self.occupied? && occupied_adjacent_seats >= 4
    should_occupy_seat = !self.occupied? && occupied_adjacent_seats == 0
    
    if (should_empty_seat)
      return Seat.new(@row, @column, false)
    end

    if (should_occupy_seat)
      return Seat.new(@row, @column, true)
    end

    return self
  end

  private

  def adjacent_seats(plane)
    seat_top_left = plane.seat_at(row_number: @row + 1, column_number: @column  - 1)
    seat_top = plane.seat_at(row_number: @row + 1, column_number: @column)
    seat_top_right = plane.seat_at(row_number: @row + 1, column_number: @column  + 1)

    seat_to_left = plane.seat_at(row_number: @row, column_number: @column  - 1)
    seat_to_right = plane.seat_at(row_number: @row, column_number: @column  + 1)

    seat_behind_left = plane.seat_at(row_number: @row - 1, column_number: @column  - 1)
    seat_behind = plane.seat_at(row_number: @row - 1, column_number: @column)
    seat_behind_right = plane.seat_at(row_number: @row - 1, column_number: @column + 1)

    return [seat_top_left, seat_top, seat_top_right, seat_to_left, seat_to_right, seat_behind_left, seat_behind, seat_behind_right].compact
  end
end

class Floor 
  def initialize(row, column)
    @row = row
    @column = column
  end

  def occupied?
    false
  end

  def iterate(plane)
    return self
  end
end