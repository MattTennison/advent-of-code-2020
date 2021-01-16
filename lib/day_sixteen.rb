class TicketRule
  attr_reader :name

  def initialize(valid_ranges, name)
    @ranges = valid_ranges
    @name = name
  end

  def valid?(number)
    @ranges.any? { |range| range.include?(number) }
  end
end

class Ticket
  def initialize(values)
    @values = values
  end

  def invalid_values(rules)
    @values.select { |value| rules.none? { |r| r.valid?(value) } }
  end

  def valid?(rules)
    if (rules.count != @values.count)
      return false
    end

    result = true
    @values.each_with_index { |value, index| result = result && rules[index].valid?(value) }
    result
  end
end

class TicketScanner
  def initialize(rule_list)
    @rule_list = rule_list
  end

  def invalid_values(tickets)
    tickets
      .map { |ticket| ticket.invalid_values(@rule_list) }
      .flatten
  end

  def valid_tickets(tickets)
    tickets
      .select { |ticket| ticket.invalid_values(@rule_list).empty? }
  end
end

class DaySixteen
  def initialize(puzzle_input)
    @input = puzzle_input
  end

  def ticket_scanning_error_rate
    TicketScanner.new(rules).invalid_values(tickets).sum
  end

  private

  def rules
    rule_regex = Regexp.new(/(\w+): (\d+)-(\d+) or (\d+)-(\d+)/)
    ranges = @input.scan(rule_regex).map do |matchdata|
      name = matchdata[0]
      first_rule_start, first_rule_end = matchdata.values_at(1, 2)
      second_rule_start, second_rule_end = matchdata.values_at(3, 4)

      TicketRule.new([
        Range.new(first_rule_start.to_i, first_rule_end.to_i),
        Range.new(second_rule_start.to_i, second_rule_end.to_i)
      ], name)
    end
  end

  def tickets
    lines = @input.split("\n").map{ |line| line.strip }
    nearby_ticket_lines = lines[(lines.index("nearby tickets:") + 1..)]
    nearby_ticket_lines.map do |str|
      values = str.split(",").map { |s| s.to_i }
      Ticket.new(values)
    end
  end
end