require "rails_helper"

RSpec.describe Question, type: :model do
  let(:topic) { Topic.create!(topic_id: 1, topic_name: "TEST TOPIC") }
  let(:type) { Type.create!(type_id: 1, type_name: "TEST TYPE") }
  let(:mc_type) { Type.create!(type_id: 2, type_name: "Multiple choice") }
  let(:question) { Question.create!(topic_id: topic.id, type_id: type.id, template_text: "TEST QUESTION") }

  describe "valid information" do
    it "is valid" do
      expect(question).to be_valid
    end

    it "is invalid without a topic_id" do
      question.topic_id = nil
      expect(question).to_not be_valid
    end

    it "is invalid without a type_id" do
      question.type_id = nil
      expect(question).to_not be_valid
    end

    it "is invalid without a template_text" do
      question.template_text = nil
      expect(question).to_not be_valid
    end

    it "is invalid with a short template_text" do
      question.template_text = "Why"
      expect(question).to_not be_valid
    end
  end

  describe "table associations" do
    it { is_expected.to have_many(:submissions).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:submissions) }

    it "belongs to a topic" do
      expect(question.topic).to eq(topic)
    end

    it "belongs to a type" do
      expect(question.type).to eq(type)
    end
  end

  describe "equation field validations" do
    let(:valid_attributes) do
      {
        topic: topic,
        type: type,
        template_text: "What is the value of [x] + [y]?",
        question_kind: "equation",
        variables: [ "x", "y" ],
        variable_ranges: [ [ 1, 10 ], [ 1, 10 ] ],
        variable_decimals: [ 2, 2 ],
        round_decimals: 2
      }
    end

    it "is valid with all fields present" do
      q = Question.new(valid_attributes)
      expect(q).to be_valid
    end

    context "invalid variable names" do
      it "is invalid with empty variable names" do
        q = Question.new(valid_attributes.merge(variables: [ "", "y" ]))
        expect(q).to_not be_valid
        expect(q.errors[:variables]).to include("must be present and non-empty.")
      end

      it "is invalid with non-alphabetic characters or underscores in variable names" do
        q = Question.new(valid_attributes.merge(variables: [ "x1....", "y" ]))
        expect(q).to_not be_valid
        expect(q.errors[:variables]).to include("must only contain letters and underscores.")
      end
    end

    context "invalid variable ranges" do
      it "is invalid with max <= min" do
        q = Question.new(valid_attributes.merge(variable_ranges: [ [ 10, 1 ], [ 1, 10 ] ]))
        expect(q).to_not be_valid
        expect(q.errors[:variable_ranges]).to include("for 'x' must have max >= min (got 10…1)")
      end
    end

    context "invalid variable decimals" do
      it "is invalid with negative decimals" do
        q = Question.new(valid_attributes.merge(variable_decimals: [ -1, 2 ]))
        expect(q).to_not be_valid
        expect(q.errors[:variable_decimals]).to include("for 'x' must be >= 0 (got -1)")
      end
    end
    context "invalid round decimals" do
      it "is invalid with negative round decimals" do
        q = Question.new(valid_attributes.merge(round_decimals: -1))
        expect(q).to_not be_valid
        expect(q.errors[:round_decimals]).to include("must be >= 0 (got -1)")
      end

      it "is valid if round_decimals is >= 0" do
        q = Question.new(valid_attributes.merge(round_decimals: 0))
        expect(q).to be_valid
      end
    end
  end

  describe "MC choice validations" do
    let(:question) { Question.new(type: mc_type, template_text: "sdfkjasdjlfhd", topic: topic, question_kind: "definition") }

    before do
      # ensure nested attributes are accepted
      question.answer_choices.clear
    end

    context "when fewer than two non-destroyed choices" do
      it "adds an error on answer_choices" do
        question.answer_choices.build(choice_text: "A", correct: false)
        expect(question.valid?).to be false
        expect(question.errors[:answer_choices]).to include("must have at least two choices.")
      end
    end

    context "when exactly two choices but none marked correct" do
      it "adds an error about exactly one correct answer" do
        2.times { question.answer_choices.build(choice_text: "X", correct: false) }
        # satisfy the first validation
        question.valid?
        expect(question.errors[:answer_choices]).to include("must have exactly one correct answer.")
      end
    end

    context "when two choices but more than one marked correct" do
      it "adds the exactly one correct answer error" do
        2.times { question.answer_choices.build(choice_text: "X", correct: true) }
        question.valid?
        expect(question.errors[:answer_choices]).to include("must have exactly one correct answer.")
      end
    end

    context "when exactly two choices and exactly one correct" do
      it "is valid" do
        question.answer_choices.build(choice_text: "A", correct: true)
        question.answer_choices.build(choice_text: "B", correct: false)
        question.valid?
      end
    end
  end

  describe "#validate_dataset_generator_format" do
    let(:q) { Question.new(question_kind: "dataset", template_text: "asfadsfasdfasdf", topic: topic, type: type) }

    it "allows blank generator" do
      q.dataset_generator = ""
      expect(q.valid?).to be true
    end

    it "rejects incorrect format" do
      q.dataset_generator = "bad-format"
      q.valid?
      expect(q.errors[:dataset_generator]).to include(
        "must be in format “min-max, size=n” (e.g. 1-25, size=10)"
      )
    end

    it "rejects when max < min" do
      q.dataset_generator = "10-5, size=3"
      q.valid?
      expect(q.errors[:dataset_generator]).to include(
        "max (5.0) must be greater than or equal to min (10.0)"
      )
    end

    it "rejects when size < 1" do
      q.dataset_generator = "1-5, size=0"
      q.valid?
      expect(q.errors[:dataset_generator]).to include(
        "size (0) must be at least 1"
      )
    end

    it "accepts a correctly formatted string" do
      q.dataset_generator = "1.5-2.5, size=4"
      q.valid?
      expect(q.valid?).to be true
    end
  end

  describe "#multiple_choice?" do
    it "returns true when the type_name is 'Multiple choice'" do
      q = Question.new(type: mc_type)
      expect(q.multiple_choice?).to be true
    end

    it "returns false for any other type" do
      q = Question.new(type: type)
      expect(q.multiple_choice?).to be false
    end
  end
end
