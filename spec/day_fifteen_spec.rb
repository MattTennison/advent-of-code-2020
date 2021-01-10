require "day_fifteen"

# For example, suppose the starting numbers are 0,3,6:

#     Turn 1: The 1st number spoken is a starting number, 0.
#     Turn 2: The 2nd number spoken is a starting number, 3.
#     Turn 3: The 3rd number spoken is a starting number, 6.
#     Turn 4: Now, consider the last number spoken, 6. Since that was the first time the number had been spoken, the 4th number spoken is 0.
#     Turn 5: Next, again consider the last number spoken, 0. Since it had been spoken before, the next number to speak is the difference between the turn number when it was last spoken (the previous turn, 4) and the turn number of the time it was most recently spoken before then (turn 1). Thus, the 5th number spoken is 4 - 1, 3.
#     Turn 6: The last number spoken, 3 had also been spoken before, most recently on turns 5 and 2. So, the 6th number spoken is 5 - 2, 3.
#     Turn 7: Since 3 was just spoken twice in a row, and the last two turns are 1 turn apart, the 7th number spoken is 1.
#     Turn 8: Since 1 is new, the 8th number spoken is 0.
#     Turn 9: 0 was last spoken on turns 8 and 4, so the 9th number spoken is the difference between them, 4.
#     Turn 10: 4 is new, so the 10th number spoken is 0.

RSpec.describe MemoryGame do
  describe "MemoryGame" do
    describe "#number_at" do
      where(:number_at, :expected_result) do
        [
          [2, 6],
          [3, 0],
          [4, 3],
          [5, 3],
          [6, 1],
          [7, 0],
          [8, 4],
          [9, 0]
        ]
      end

      with_them do
        it "returns the expected result" do
          initialisation_sequence = [0, 3, 6]
          game = MemoryGame.new(initialisation_sequence)

          result = game.number_at(number_at)

          expect(result).to equal(expected_result)
        end
      end

      it "returns 1836 for 2020th number given starting numbers are 3,1,2" do
        initialisation_sequence = [3, 1, 2]
        game = MemoryGame.new(initialisation_sequence)

        result = game.number_at(2019)

        expect(result).to equal(1836)
      end
    end
  end
end