# frozen_string_literal: true

require 'day_seven'

RSpec.describe BagRules do
  describe 'Bag Problem' do
    it 'returns 4 for number of bags that could contain a shiny gold bag' do
      rules = [
        'light red bags contain 1 bright white bag, 2 muted yellow bags.',
        'dark orange bags contain 3 bright white bags, 4 muted yellow bags.',
        'bright white bags contain 1 shiny gold bag.',
        'muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.',
        'shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.',
        'dark olive bags contain 3 faded blue bags, 4 dotted black bags.',
        'vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.',
        'faded blue bags contain no other bags.',
        'dotted black bags contain no other bags.'
      ]

      factory = BagRules.new(rules).factory

      expect(factory.get_wrapping_bag_colors('shiny gold').count).to equal(4)
    end

    it 'returns 3 for number of bags that could contain a shiny gold bag' do
      rules = [
        'dark orange bags contain 3 bright white bags, 4 muted yellow bags.',
        'bright white bags contain 1 shiny gold bag.',
        'muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.',
        'shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.',
        'dark olive bags contain 3 faded blue bags, 4 dotted black bags.',
        'vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.',
        'faded blue bags contain no other bags.',
        'dotted black bags contain no other bags.'
      ]

      factory = BagRules.new(rules).factory

      expect(factory.get_wrapping_bag_colors('shiny gold').count).to equal(3)
    end

    describe '#number_of_bag_tickets' do
      it 'returns 127 bags for a shiny gold bag' do
        rules = [
          'shiny gold bags contain 2 dark red bags.',
          'dark red bags contain 2 dark orange bags.',
          'dark orange bags contain 2 dark yellow bags.',
          'dark yellow bags contain 2 dark green bags.',
          'dark green bags contain 2 dark blue bags.',
          'dark blue bags contain 2 dark violet bags.',
          'dark violet bags contain no other bags.'
        ]

        factory = BagRules.new(rules).factory

        expect(factory.number_of_bag_tickets('shiny gold')).to equal(127)
      end

      it 'returns 33 bags for a shiny gold bag' do
        rules = [
          'light red bags contain 1 bright white bag, 2 muted yellow bags.',
          'dark orange bags contain 3 bright white bags, 4 muted yellow bags.',
          'bright white bags contain 1 shiny gold bag.',
          'muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.',
          'shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.',
          'dark olive bags contain 3 faded blue bags, 4 dotted black bags.',
          'vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.',
          'faded blue bags contain no other bags.',
          'dotted black bags contain no other bags.'
        ]

        factory = BagRules.new(rules).factory

        expect(factory.number_of_bag_tickets('shiny gold')).to equal(33)
      end
    end
  end
end
