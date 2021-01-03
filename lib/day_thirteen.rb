class Bus
  def departing_at?(timestamp)
    raise "should be overridden by subclass"
  end

  def waiting_time_for_next_departure(timestamp)
    raise "should be overridden by subclass"
  end
end

class InServiceBus < Bus
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def waiting_time_for_next_departure(timestamp)
    minutes_since_last_departure = timestamp % @id

    return 0 if minutes_since_last_departure === 0

    return gap_between_depatures - minutes_since_last_departure
  end

  def departing_at?(timestamp)
    timestamp % gap_between_depatures == 0
  end

  private

  def gap_between_depatures
    @id
  end
end

class OutOfServiceBus < Bus
  def id
    1
  end

  def waiting_time_for_next_departure(timestamp)
    nil
  end

  def departing_at?(timestamp)
    true
  end
end

class BusFactory
  def self.from_input(input_str)
    if (input_str.eql?("x"))
      return OutOfServiceBus.new
    end

    return InServiceBus.new(input_str.to_i)
  end
end

class BusSchedule
  def initialize(schedule)
    @buses = schedule.map { |s| BusFactory.from_input(s) }
  end

  def next_bus(timestamp)
    @buses
      .reject { |bus| bus.waiting_time_for_next_departure(timestamp).eql?(nil) }
      .sort { |bus_a, bus_b| bus_a.waiting_time_for_next_departure(timestamp) <=> bus_b.waiting_time_for_next_departure(timestamp) }.first
  end

  def sequential_departure_timestamp
    timestamp = 0
    matched_buses = @buses.select { |b| b.waiting_time_for_next_departure(timestamp) == @buses.index(b) }

    increment = matched_buses.reduce(1) {|acc, bus| acc * bus.id}

    unmatched_buses = @buses - matched_buses
    next_bus_to_match = unmatched_buses.first
    index_of_next_bus_to_match = @buses.index(next_bus_to_match)

    while (unmatched_buses.count > 0) do
      timestamp = timestamp + increment     
      if (next_bus_to_match.departing_at?(timestamp + index_of_next_bus_to_match))
        unmatched_buses.delete(next_bus_to_match)
        matched_buses << next_bus_to_match
        
        increment = increment * next_bus_to_match.id

        next_bus_to_match = unmatched_buses.first
        index_of_next_bus_to_match = @buses.index(next_bus_to_match)
      end
    end

    timestamp
  end
end

class BusNoteParser
  def initialize(note)
    timestamp, buses_str = note.split("\n")

    buses = buses_str.split(",")

    @timestamp = timestamp.to_i
    @bus_schedule = BusSchedule.new(buses)
  end

  def part_one_answer
    next_bus = @bus_schedule.next_bus(@timestamp)
    waiting_time = next_bus.waiting_time_for_next_departure(@timestamp)

    return next_bus.id * waiting_time
  end

  def part_two_answer
    @bus_schedule.sequential_departure_timestamp
  end
end