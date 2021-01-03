class Bus
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def waiting_time_for_next_departure(timestamp)
    minutes_since_last_departure = timestamp % @id

    return 0 if minutes_since_last_departure === 0

    return gap_between_depatures - minutes_since_last_departure
  end

  private

  def gap_between_depatures
    @id
  end
end

class BusSchedule
  def initialize(schedule)
    @buses = schedule.map { |s| Bus.new(s) }
  end

  def next_bus(timestamp)
    return nil if @buses.count === 0

    @buses.sort { |bus_a, bus_b| bus_a.waiting_time_for_next_departure(timestamp) <=> bus_b.waiting_time_for_next_departure(timestamp) }.first
  end
end

class BusNoteParser
  def initialize(note)
    timestamp, buses_str = note.split("\n")

    buses = buses_str.split(",").reject {|str| str.eql?("x")}.map{|str| str.to_i}

    @timestamp = timestamp.to_i
    @bus_schedule = BusSchedule.new(buses)
  end

  def part_one_answer
    next_bus = @bus_schedule.next_bus(@timestamp)
    waiting_time = next_bus.waiting_time_for_next_departure(@timestamp)

    return next_bus.id * waiting_time
  end
end