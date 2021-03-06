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
    minutes_since_last_departure = timestamp % gap_between_departures
    
    return 0 if minutes_since_last_departure === 0
    
    return gap_between_departures - minutes_since_last_departure
  end
  
  def departing_at?(timestamp)
    timestamp % gap_between_departures == 0
  end
  
  private
  
  def gap_between_departures
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
      .sort { |bus_a, bus_b| bus_a.waiting_time_for_next_departure(timestamp) <=> bus_b.waiting_time_for_next_departure(timestamp) }
      .first
  end

  def sequential_departure_timestamp
    timestamp = 0
    list = MatchingBusList.new(@buses)

    while (!list.all_matched?(timestamp)) do
      timestamp += list.interval(timestamp)
    end

    timestamp
  end
end

class MatchingBusList
  def initialize(buses)
    @buses = buses
  end

  def matched_buses(timestamp)
    @buses.select { |b| b.departing_at?(timestamp + @buses.index(b)) }
  end

  def interval(timestamp)
    matched_buses(timestamp).reduce(1) { |acc, bus| acc * bus.id }
  end

  def all_matched?(timestamp)
    matched_buses(timestamp).count == @buses.count
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