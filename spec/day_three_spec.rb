# frozen_string_literal: true

require 'day_three'

RSpec.describe DayThree do
  describe 'solve' do
    where(:input, :right_delta_per_turn, :down_delta_per_turn, :answer) do
      [
        [".##\n###\n###", 1, 1, 2],
        [".##\n###\n###", 1, 2, 1],
        ["...\n...\n...", 1, 1, 0],
        ["...\n###\n...", 1, 2, 0],
        [".##\n.#.\n..#", 1, 1, 2]
      ]
    end

    with_them do
      describe "in a #{params[:right_delta_per_turn]}x#{params[:down_delta_per_turn]} toboggan" do
        it "hits #{params[:answer]} trees when going down #{params[:input]} " do
          expect(DayThree.new(input).solve(right_delta_per_turn, down_delta_per_turn)).to eq(answer)
        end
      end
    end
  end
end
