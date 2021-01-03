# frozen_string_literal: true

require 'day_five'

RSpec.describe BoardingPass do
  describe 'BoardingPass' do
    where(:pass, :expected_seat_id) do
      [
        ['FBFBBFFRLR', 357],
        ['BFFFBBFRRR', 567],
        ['FFFBBBFRRR', 119],
        ['BBFFBBFRLL', 820]
      ]
    end

    with_them do
      it "gives pass #{params[:pass]} the seat ID #{params[:expected_seat_id]}" do
        boarding_pass = BoardingPass.new(pass)
        expect(boarding_pass.seat_id).to eq(expected_seat_id)
      end
    end
  end
end

RSpec.describe Flight do
  describe 'Flight' do
    where(:present_passes, :missing_seat_id) do
      [
        [%w[FBFBBFFRLR FBFBBFFRRR], 358]
      ]
    end

    with_them do
      it "identifies #{params[:missing_seat_id]} as a missing seat ID" do
        boarding_passes = present_passes.map { |pass| BoardingPass.new(pass) }
        flight = Flight.new(boarding_passes)

        expect(flight.missing_seat_ids).to include(missing_seat_id)
      end
    end
  end
end
