require "day_ten"

RSpec.describe JoltageAdapterCollection do
  describe "JoltageAdapterCollection" do
    describe "#makeChain" do
      it "returns nil if the chain cannot be made" do
        adapters = [ 1, 2, 6, 10 ]

        collection = JoltageAdapterCollection.new(adapters)
        chain = collection.chain()

        expect(chain).to equal(nil)
      end

      it "returns array of chains if there are suitable adapters" do
        adapters = [ 1, 2, 5, 7 ]

        collection = JoltageAdapterCollection.new(adapters)
        chain = collection.chain()

        expect(chain).not_to equal(nil)
        expect(chain.count).to equal(3)
      end
    end

    describe "#solve_advent_challenge" do
      it "returns 35 for example input" do
        adapters = [ 16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4 ]

        collection = JoltageAdapterCollection.new(adapters)
        answer = collection.solve_advent_challenge

        expect(answer).to equal(35)
      end
    end

    describe "#solve_second_advent_challenge" do
      it "returns 8 for small example input" do
        adapters = [ 16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4 ]

        collection = JoltageAdapterCollection.new(adapters)
        answer = collection.solve_second_advent_challenge

        expect(answer).to equal(8)
      end

      it "returns 19208 for larger example input" do
        adapters = [ 28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19, 38, 39, 11, 1, 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3 ]

        collection = JoltageAdapterCollection.new(adapters)
        answer = collection.solve_second_advent_challenge

        expect(answer).to equal(19208)
      end
    end
  end
end
