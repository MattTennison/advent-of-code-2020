require "day_sixteen"

RSpec.describe TicketRule do
  describe "TicketRule" do
    describe "#valid?" do
      it "considers a value in the middle of a range valid" do
        rule = TicketRule.new([(1..5)])

        result = rule.valid?(3)

        expect(result).to equal(true)
      end

      it "considers a value outside the range invalid" do
        rule = TicketRule.new([(1..5)])

        result = rule.valid?(8)

        expect(result).to equal(false)
      end

      it "considers a value in the middle of one of several ranges to be valid" do
        rule = TicketRule.new([(1..5), (7..10)])

        result = rule.valid?(8)

        expect(result).to equal(true)
      end

      it "considers a value in the middle of two overlapping ranges to be valid" do
        rule = TicketRule.new([(1..5), (3..10)])

        result = rule.valid?(4)

        expect(result).to equal(true)
      end
    end
  end

  describe "Ticket" do
    describe "#invalid_values" do
      it "returns all values when no ticket rules" do
        rules = []
        values = [101, 102, 103]
        ticket = Ticket.new(values)

        result = ticket.invalid_values(rules)

        expect(result).to eq(values)
      end

      it "returns no values when ticket rules cover all values" do
        rules = [TicketRule.new([(101..103)])]
        values = [101, 102, 103]
        ticket = Ticket.new(values)

        result = ticket.invalid_values(rules)

        expect(result).to eq([])
      end

      it "returns invalid values where no ticket rule covers the value" do
        rules = [TicketRule.new([(101..103)]), TicketRule.new([(107..109)])]
        values = [101, 105, 109]
        ticket = Ticket.new(values)

        result = ticket.invalid_values(rules)

        expect(result).to eq([105])
      end
    end
  end

  describe "TicketScanner" do
    it "returns all the invalid values for all the invalid tickets" do
      single_digit_rule = TicketRule.new([(1..9)])
      twenty_to_fourty_rule = TicketRule.new([(20..40)])
      scanner = TicketScanner.new([single_digit_rule, twenty_to_fourty_rule])
      tickets = [
        Ticket.new([13, 20, 40, 5]),
        Ticket.new([6, 11, 21, 34])
      ]

      result = scanner.invalid_values(tickets)

      expect(result).to match_array([11, 13])
    end
  end
end

describe "DaySixteen" do
  describe "#ticket_scanning_error_rate" do
    it "returns 71 for sample input" do
      input = "class: 1-3 or 5-7
        row: 6-11 or 33-44
        seat: 13-40 or 45-50
        
        your ticket:
        7,1,14
        
        nearby tickets:
        7,3,47
        40,4,50
        55,2,20
        38,6,12"
      day_sixteen = DaySixteen.new(input)

      result = day_sixteen.ticket_scanning_error_rate

      expect(result).to eq(71)
    end
  end
end