require "day_six"

RSpec.describe Group do
  describe "Group" do
    where(:group_input, :expected_count, :expected_unanimous_count) do
      [
        ["a\nab\na\nb", 2, 0],
        ["abc\nab\nabc", 3, 2],
        ["a\nb\nc", 3, 0]
      ]
    end

    with_them do
      it "calculates the count correctly" do
        group = Group.new(group_input)
        expect(group.count).to eq(expected_count)
      end

      it "calculates the unanimous count correctly" do
        group = Group.new(group_input)
        expect(group.unanimous_count).to eq(expected_unanimous_count)
      end
    end
  end
end