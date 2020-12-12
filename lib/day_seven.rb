class BagFactory
  def initialize(rules)
    @requirements_per_color = Hash.new
    @wrappers_per_color = Hash.new()

    rules.each do |rule|
      @requirements_per_color.store(rule[:color], rule[:inner_contents])
    end

    
    rules.each do |rule|
      inner_colors = rule[:inner_contents].to_set
      
      inner_colors.each do |color|
        wrappers = @wrappers_per_color.key?(color) ? @wrappers_per_color[color] : Set.new
        wrappers.add(rule[:color])
        @wrappers_per_color.store(color, wrappers)
      end
    end

  end

  def get_wrapping_bag_colors(search_color)
    has_wrappers =  @wrappers_per_color.key?(search_color)
    if (!has_wrappers)
      return []
    end

    wrappers = @wrappers_per_color[search_color]
    wrappers.to_a.reduce(Array.new) do |acc, wrapping_color|
      acc.concat(self.get_wrapping_bag_colors(wrapping_color).to_a)
      acc
    end.concat(wrappers.to_a).to_set
  end

  def number_of_bag_tickets(bag_color)
    requirements = @requirements_per_color[bag_color]
    if (requirements.eql?([]))
      return 1
    end

    requirements.sum{|r| self.number_of_bag_tickets(r) } + 1
  end
end

class BagRules
  def initialize(rules)
    @rules = rules
  end

  def factory
    parsed_rules = @rules.map do |r|
      captures = r.match(/^([\w\s]+) bags contain (.+)$/).captures
      bag_color = captures[0]
      inner_contents_str = captures[1]

      inner_contents = inner_contents_str.eql?("no other bags.") ? [] : inner_contents_str.split(",").map do |inner_contents| 
        captures = inner_contents.match(/(\d+) ([\w\s]+) bag|bags/).captures
        Array.new(captures[0].to_i, captures[1])
      end.flatten

      { :color => bag_color, :inner_contents => inner_contents }
    end

    BagFactory.new(parsed_rules)
  end
end