# spec/helpers/dataset_processor_helper_spec.rb
require 'rails_helper'

RSpec.describe DatasetProcessorHelper, type: :helper do
  describe "#generate_dataset" do
    it "returns correct dataset from generator string" do
      controller = PracticeController.new
      dataset = helper.generate_dataset("1-1, size=5")
      expect(dataset).to eq([ 1, 1, 1, 1, 1 ])
    end

    it "returns empty array for blank generator" do
      controller = PracticeController.new
      expect(helper.generate_dataset(nil)).to eq([])
    end
  end

  describe "#compute_dataset_answer" do
    it "computes mean correctly" do
      result = helper.compute_dataset_answer([ 1, 2, 3 ], "mean")
      expect(result).to eq(2.0)
    end

    it "computes median correctly (odd)" do
      result = helper.compute_dataset_answer([ 3, 1, 2 ], "median")
      expect(result).to eq(2)
    end

    it "computes median correctly (even)" do
      result = helper.compute_dataset_answer([ 1, 2, 3, 4 ], "median")
      expect(result).to eq(2.5)
    end

    it "computer range correctly" do
      result = helper.compute_dataset_answer([ 1, 2, 3 ], "range")
      expect(result).to eq(2)
    end

    it "computes standard deviation correctly" do
      result = helper.compute_dataset_answer([ 1, 2, 3 ], "standard_deviation")
      expect(result).to eq(0.82)
    end

    it "computes variance correctly" do
      result = helper.compute_dataset_answer([ 1, 2, 3 ], "variance")
      expect(result).to eq(0.67)
    end

    it "computes mode correctly" do
      result = helper.compute_dataset_answer([ 1, 2, 2, 3 ], "mode")
      expect(result).to eq(2)
    end

    it "returns nil for unknown strategy" do
      result = helper.compute_dataset_answer([ 1, 2 ], "unknown")
      expect(result).to be_nil
    end
  end
end