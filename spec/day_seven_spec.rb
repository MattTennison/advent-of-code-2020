require "day_seven"

RSpec.describe BagRules do
  describe "Bag Problem" do
    it "returns a green bag with two nested red bags given rule" do
        green_bag_rule = "green bags contain 2 red bags"
        red_bag_rule = "red bags contain no other bags."
        factory = BagRules.new([green_bag_rule, red_bag_rule]).factory
        green_bag = factory.bag("green")

        expect(green_bag).not_to equal(nil)
        expect(green_bag.inner_bags.count).to equal(2)
    end

    it "returns 4 for number of bags that could contain a shiny gold bag" do
      rules = [
        "light red bags contain 1 bright white bag, 2 muted yellow bags.",
        "dark orange bags contain 3 bright white bags, 4 muted yellow bags.",
        "bright white bags contain 1 shiny gold bag.",
        "muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.",
        "shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.",
        "dark olive bags contain 3 faded blue bags, 4 dotted black bags.",
        "vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.",
        "faded blue bags contain no other bags.",
        "dotted black bags contain no other bags."
      ]

      factory = BagRules.new(rules).factory

      puts factory.get_nested_wrappers_for("shiny gold")
      expect(factory.get_nested_wrappers_for("shiny gold").count).to equal(4)
    end
  end
end