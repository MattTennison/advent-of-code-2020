# frozen_string_literal: true

require 'day_eleven'

RSpec.describe Ferry do
  describe 'Ferry' do
    input = nil

    before(:each) do
      input = "#.##.##.##
        #######.##
        #.#.#..#..
        ####.##.##
        #.##.##.##
        #.#####.##
        ..#.#.....
        ##########
        #.######.#
        #.#####.##"
    end

    describe '#occupied' do
      it 'should return 71 if all 71 seats are occupied' do
        ferry = Ferry.new(input)

        expect(ferry.occupied).to equal(71)
      end

      it 'should return 70 if 70 seats are occupied and 1 is empty' do
        input = "#.##.L#.##
          #######.##
          #.#.#..#..
          ####.##.##
          #.##.##.##
          #.#####.##
          ..#.#.....
          ##########
          #.######.#
          #.#####.##"

        ferry = Ferry.new(input)

        expect(ferry.occupied).to equal(70)
      end
    end

    describe '#seat_at' do
      it 'should return nil given a negative row' do
        ferry = Ferry.new(input)

        expect(ferry.seat_at(row_number: -1, column_number: 0)).to equal(nil)
      end

      it 'should return nil given a negative column' do
        ferry = Ferry.new(input)

        expect(ferry.seat_at(row_number: 0, column_number: -1)).to equal(nil)
      end

      it 'should return seat given valid row and column' do
        ferry = Ferry.new(input)
        seat = ferry.seat_at(row_number: 1, column_number: 1)

        expect(seat).not_to equal(nil)
        expect(seat).to be_an_instance_of(Seat)
      end
    end

    describe '#iterate' do
      describe 'with immediate seat finding strategy' do
        it 'should change an empty seat with no adjacent occupied seats to an occupied seat' do
          input = "#.##.##.##
            #######.##
            #.#.#..#..
            ###L.L#.##
            #.#.L.#.##
            #.#...#.##
            ..#.#.....
            ##########
            #.######.#
            #.#####.##"

          ferry = Ferry.new(input)
          ferry.iterate(ImmediateSeatFindingStrategy.new(ferry))

          expect(ferry.seat_at(row_number: 4, column_number: 4).occupied?).to equal(true)
        end

        it 'should change an occupied seat with 4 adjacent occupied seats to an empty seat' do
          ferry = Ferry.new(input)
          ferry.iterate(ImmediateSeatFindingStrategy.new(ferry))

          expect(ferry.seat_at(row_number: 1, column_number: 4).occupied?).to equal(false)
        end
      end

      describe 'with visible seat finding strategy' do
        it 'should turn a seat with 5 empty adjacent seats to an occupied seat' do
          input = ".##.##.
            #L#.#L#
            ##...##
            L..L..L
            ##...##
            #L#.#L#
            .##.##."

          ferry = Ferry.new(input)
          ferry.iterate(VisibleSeatFindingStrategy.new(ferry))

          expect(ferry.seat_at(row_number: 3, column_number: 3).occupied?).to equal(true)
        end

        it 'should not turn a empty seat with 5 occupied adjacent seats to an occupied seat' do
          input = ".##.##.
            ###.###
            ##...##
            #..L..#
            ##...##
            ###.###
            .##.##."

          ferry = Ferry.new(input)
          ferry.iterate(VisibleSeatFindingStrategy.new(ferry))

          expect(ferry.seat_at(row_number: 3, column_number: 3).occupied?).to equal(false)
        end
      end
    end

    describe '#stabilise' do
      it 'should stabilise on 37 occupied seats for sample input with default rules' do
        ferry = Ferry.new(input)
        ferry.stabilise(ImmediateSeatFindingStrategy.new(ferry))

        expect(ferry.occupied).to equal(37)
      end

      it 'should stabilise on 26 occupied seats for sample input when 5 adjacent seats can be occupied and visible seats are occupied' do
        ferry = Ferry.new(input)
        rules = [TooCrowdedSeatingRule.new(4), SpaciousSeatingRule.new]
        strategy = VisibleSeatFindingStrategy.new(ferry)
        ferry.stabilise(strategy, rules)

        expect(ferry.occupied).to equal(26)
      end
    end
  end
end
