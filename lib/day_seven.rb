class Bag
  def initialize(color, inner_bags)
    @color = color
    @inner_bags = inner_bags
  end

  def color
    color
  end

  def inner_bags
    @inner_bags
  end
end

class BagFactory
  def initialize(rules)
    @requirements_per_color = Hash.new
    @requirements = []

    rules.each do |rule|
      @requirements_per_color.store(rule[:color], rule[:inner_contents])
      @requirements.push(rule)
    end
  end

  def bag(color)
    requirements = @requirements_per_color[color]

    if (requirements.count.eql?(0)) 
      return Bag.new(color, [])
    end

    inner_contents = requirements.map do |r|
      self.bag(r)
    end

    Bag.new(color, inner_contents)
  end

  def get_nested_wrappers_for(color)
    wrappers = self.get_wrappers_for(color)

    outer_wrappers = wrappers.map do |wrapper|
      self.get_wrappers_for(wrapper[:color])
    end.flatten

    all_wrappers = Array.new(wrappers).concat(outer_wrappers)

    all_wrappers.map {|w| w[:color]}.to_set
  end

  private 
  
  def get_wrappers_for(color)
    @requirements.select do |r|
      r[:inner_contents].include?(color)
    end
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