require "day_thirteen"

RSpec.describe Bus do
  describe "Bus" do
    describe "#waiting_time_for_next_departure" do
      where(:id, :timestamp, :expected_next_departure) do
        [
          [5, 10, 0],
          [5, 9, 1],
          [7, 49, 0],
          [7, 51, 5],
          [10, 0, 0],
          [10, 1, 9]
        ]
      end

      with_them do
        it "returns the expected next departure" do
          bus = Bus.new(id)

          next_departure = bus.waiting_time_for_next_departure(timestamp)

          expect(next_departure).to equal(expected_next_departure)
        end
      end
    end
  end
end

RSpec.describe BusSchedule do
  describe "BusSchedule" do
    describe "#next_bus" do
      it "returns nil if no buses are in the schedule" do
        bus_schedule = BusSchedule.new([])

        next_bus = bus_schedule.next_bus(900)

        expect(next_bus).to equal(nil)
      end

      it "returns bus 59 given sample input and timestamp" do
        buses = [7,13,59,31,19]
        bus_schedule = BusSchedule.new(buses)

        next_bus = bus_schedule.next_bus(939)

        expect(next_bus).not_to equal(nil)
        expect(next_bus.id).to equal(59)
      end
    end
  end
end

RSpec.describe BusNoteParser do
  describe "BusNoteParser" do
    describe "#part_one_answer" do
      where(:note, :expected_answer) do
        [
          ["939\n7,13,x,x,59,x,31,19", 5 * 59],
          ["939\n7,13,x,x,x,31,19", 6 * 7],
          ["929\n7,13,x,x,59,x,31,19", 1 * 31],
          ["932\n7,13,x,x,59,x,31,19", 4 * 13]
        ]
      end

      with_them do
        it "returns the right answer" do
          note_parser = BusNoteParser.new(note)

          part_one_answer = note_parser.part_one_answer

          expect(part_one_answer).to equal(expected_answer)
        end
      end
    end
  end
end