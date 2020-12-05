require "day_four"

RSpec.describe Passport do
  describe 'is_valid' do
    where(:input, :is_valid) do
      [
        ["ecl:gry pid:860033327 eyr:2020 hcl:#fffffd\nbyr:1937 iyr:2017 cid:147 hgt:183cm", true],
        ["iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884\nhcl:#cfa07d byr:1929", false],
        ["hcl:#ae17e1 iyr:2013\neyr:2024\necl:brn pid:760753108 byr:1931\nhgt:179cm", true],
        ["hcl:dab227 iyr:2012 ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277", false],
        ["eyr:1972 cid:100\nhcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926", false],
        ["iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719", true]
      ]
    end

    with_them do
      it "considers the input to be #{params[:is_valid] ? "valid" : "invalid"} " do
        expect(Passport.new(input).is_valid?).to eq(is_valid)
      end
    end
  end

  describe 'is_valid_height' do
    describe 'valid height values' do
      where(:input) do
        [
          ["160cm"], ["156cm"], ["60in"], ["76in"]
        ]
      end

      with_them do
        it "considers them valid values" do
          expect(Passport.new("hcl:#ae17e1 iyr:2013\neyr:2024\necl:brn pid:760753108 byr:1931\nhgt:" + input).is_valid_height?).to eq(true)
        end
      end
    end

    describe 'invalid height values' do
      where(:input) do
        [
          ["60cm"], ["256cm"], ["6in"], ["86in"]
        ]
      end

      with_them do
        it "considers them invalid values" do
          expect(Passport.new("hcl:#ae17e1 iyr:2013\neyr:2024\necl:brn pid:760753108 byr:1931\nhgt:" + input).is_valid_height?).to eq(false)
        end
      end
    end
  end

  describe 'is_valid_eye_color' do
    where(:input) do
      [
        ["amb"], ["blu"], ["brn"], ["gry"], ["grn"], ["hzl"], ["oth"]
      ]
    end

    with_them do
      it "considers them valid" do
        expect(Passport.new("hcl:#ae17e1 iyr:2013\neyr:2024\npid:760753108 byr:1931\nhgt:176cm ecl:" + input).is_valid_eye_color?).to eq(true)
      end
    end

    it "considers unknown eye colour values invalid" do
      eye_color = "foobar"
      expect(Passport.new("hcl:#ae17e1 iyr:2013\neyr:2024\npid:760753108 byr:1931\nhgt:176cm ecl:" + eye_color).is_valid_eye_color?).to eq(false)
    end
  end

  describe "is_valid_passport_id" do
    where(:case_name, :passport_id, :is_valid) do
      [
        ["considers 9-digit numbers valid", "890438234", true],
        ["considers 8-digit numbers with 1 leading zero valid", "090438234", true],
        ["considers 7-digit numbers with 2 leading zeros valid", "000438234", true],
        ["considers 10-digit numbers invalid", "8904382341", false],
        ["considers 9-alphanumeric characters invalid", "foobar123", false]
      ]
    end

    with_them do
      it "considers them #{params[:is_valid] ? "valid" : "invalid"}" do
        expect(Passport.new("hcl:#ae17e1 iyr:2013\neyr:2024\necl:brn byr:1931\nhgt:175cm pid:" + passport_id).is_valid_passport_id?).to eq(is_valid)
      end
    end
  end
end

RSpec.describe PassportControl do
  describe 'solve' do
    where(:input, :number_of_valid_passports) do
      [
        ["ecl:gry pid:860033327 eyr:2020 hcl:#fffffd\nbyr:1937 iyr:2017 cid:147 hgt:183cm\n\niyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884\nhcl:#cfa07d byr:1929", 1],
      ]
    end

    with_them do
      it "considers #{params[:number_of_valid_passports]} passports to be valid" do
        expect(PassportControl.new(input).count_valid_passports()).to eq(number_of_valid_passports)
      end
    end
  end
end