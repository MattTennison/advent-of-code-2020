# frozen_string_literal: true

class Passport
  def initialize(input)
    # @properties = input.gsub('\n', ' ').split(' ').map{|s| s.split(':')[0]}.to_set
    @properties = input.gsub('\n', ' ').split(' ').map { |s| s.split(':') }.each_with_object({}) do |prop, hash|
      hash.store(prop[0], prop[1])
    end
  end

  def valid?
    required_properties = Set['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid']
    @properties.keys.to_set.superset?(required_properties) &&
      @properties['byr'].to_i.between?(1920, 2002) &&
      @properties['iyr'].to_i.between?(2010, 2020) &&
      @properties['eyr'].to_i.between?(2020, 2030) &&
      valid_height? &&
      @properties['hcl'].match?(/#[\w\d]{6}/) &&
      valid_eye_color? &&
      valid_passport_id?
  end

  def valid_height?
    height = @properties['hgt']

    return height.to_i.between?(59, 76) if height.end_with?('in')

    return height.to_i.between?(150, 193) if height.end_with?('cm')

    false
  end

  def valid_eye_color?
    eye_color = @properties['ecl']

    %w[amb blu brn gry grn hzl oth].include?(eye_color)
  end

  def valid_passport_id?
    passport_id = @properties['pid']

    passport_id.match?(/^\d{9}$/)
  end
end

class PassportControl
  def initialize(input)
    @passports = input.split("\n\n").map { |passport| Passport.new(passport) }
  end

  def count_valid_passports
    @passports.count(&:valid?)
  end
end
