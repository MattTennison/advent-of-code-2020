# frozen_string_literal: true

class BoardingPass
  def initialize(pass)
    @pass = pass
  end

  attr_reader :pass

  def seat_id
    (row * 8) + seat
  end

  private

  def row
    row_data_in_pass = @pass.slice(0, 7)
    row = row_data_in_pass.chars.reduce(Range.new(0, 127)) do |acc, character|
      mid_point = acc.min + (acc.size / 2)
      character.eql?('F') ? Range.new(acc.min, mid_point - 1) : Range.new(mid_point, acc.max)
    end.first
  end

  def seat
    seat_data_in_pass = @pass.slice(7, 3)
    seat = seat_data_in_pass.chars.reduce(Range.new(0, 7)) do |acc, character|
      mid_point = acc.min + (acc.size / 2)
      character.eql?('L') ? Range.new(acc.min, mid_point - 1) : Range.new(mid_point, acc.max)
    end.first
  end
end

class Flight
  def initialize(boarding_passes)
    @boarding_passes = boarding_passes
  end

  def missing_seat_ids
    max_row = 127
    max_seat = 8
    max_seat_id = 127 * 8 + 8

    Set.new(1...max_seat_id) - @boarding_passes.map(&:seat_id)
  end
end
