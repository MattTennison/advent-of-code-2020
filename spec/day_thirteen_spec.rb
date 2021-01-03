# frozen_string_literal: true

require 'day_thirteen'

RSpec.describe InServiceBus do
  describe 'InServiceBus' do
    describe '#waiting_time_for_next_departure' do
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
        it 'returns the expected next departure' do
          bus = InServiceBus.new(id)

          next_departure = bus.waiting_time_for_next_departure(timestamp)

          expect(next_departure).to equal(expected_next_departure)
        end
      end
    end

    describe '#departing_at?' do
      where(:id, :timestamp, :expected_answer) do
        [
          [5, 10, true],
          [5, 0, true],
          [5, 4, false],
          [5, 7540, true],
          [3, 3, true],
          [10, 0, true],
          [10, 43, false],
          [754, 0, true],
          [754, 1508, true]
        ]
      end

      with_them do
        it 'returns the expected answer' do
          bus = InServiceBus.new(id)

          departing_at = bus.departing_at?(timestamp)

          expect(departing_at).to equal(expected_answer)
        end
      end
    end
  end
end

RSpec.describe OutOfServiceBus do
  describe 'OutOfServiceBus' do
    describe '#departing_at?' do
      where(:timestamp) do
        [
          [10], [20], [0], [9000]
        ]
      end

      with_them do
        it 'always returns true' do
          bus = OutOfServiceBus.new

          departing_at = bus.departing_at?(timestamp)

          expect(departing_at).to equal(true)
        end
      end
    end
  end
end

RSpec.describe BusSchedule do
  describe 'BusSchedule' do
    describe '#next_bus' do
      it 'returns nil if no buses are in the schedule' do
        bus_schedule = BusSchedule.new([])

        next_bus = bus_schedule.next_bus(900)

        expect(next_bus).to equal(nil)
      end

      it 'returns bus 59 given sample input and timestamp' do
        buses = [7, 13, 59, 31, 19]
        bus_schedule = BusSchedule.new(buses)

        next_bus = bus_schedule.next_bus(939)

        expect(next_bus).not_to equal(nil)
        expect(next_bus.id).to equal(59)
      end
    end
  end
end

RSpec.describe BusNoteParser do
  describe 'BusNoteParser' do
    describe '#part_one_answer' do
      where(:note, :expected_answer) do
        [
          ["939\n7,13,x,x,59,x,31,19", 5 * 59],
          ["939\n7,13,x,x,x,31,19", 6 * 7],
          ["929\n7,13,x,x,59,x,31,19", 1 * 31],
          ["932\n7,13,x,x,59,x,31,19", 4 * 13]
        ]
      end

      with_them do
        it 'returns the right answer' do
          note_parser = BusNoteParser.new(note)

          part_one_answer = note_parser.part_one_answer

          expect(part_one_answer).to equal(expected_answer)
        end
      end
    end

    describe '#part_two_answer' do
      where(:note, :expected_answer) do
        [
          ["939\n7,13,x,x,59,x,31,19", 1_068_781],
          ["939\n2,3,5", 8],
          ["939\n17,x,13,19", 3417],
          ["939\n67,7,59,61", 754_018],
          ["939\n67,x,7,59,61", 779_210],
          ["939\n67,7,x,59,61", 1_261_476],
          ["939\n1789,37,47,1889", 1_202_161_486],
          [
            "1002618\n19,x,x,x,x,x,x,x,x,41,x,x,x,37,x,x,x,x,x,367,x,x,x,x,x,x,x,x,x,x,x,x,13,x,x,x,17,x,x,x,x,x,x,x,x,x,x,x,29,x,373,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,23", 560_214_575_859_998
          ]
        ]
      end

      with_them do
        it 'returns the right answer' do
          note_parser = BusNoteParser.new(note)

          part_two_answer = note_parser.part_two_answer

          expect(part_two_answer).to equal(expected_answer)
        end
      end
    end
  end
end
