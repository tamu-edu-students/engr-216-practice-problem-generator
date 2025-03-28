# spec/controllers/problems_controller_spec.rb
require 'rails_helper'

RSpec.describe ProblemsController, type: :controller do
  let!(:topic) { create(:topic, topic_id: 1, topic_name: "Motion") }
  let!(:type)  { create(:type, type_id: 1, type_name: "Free Response") }
  let!(:user)  { create(:user, role: :student) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #problem_form' do
    it 'clears session keys related to problem state' do
      session[:submitted_answer] = "test"
      session[:solution] = "test"
      session[:question_text] = "test"
      session[:question_img] = "test"
      session[:question_id] = 1
      session[:try_another_problem] = true
      session[:is_correct] = false
      session[:explanation] = "explain"

      get :problem_form

      expect(session[:submitted_answer]).to be_nil
      expect(session[:solution]).to be_nil
      expect(session[:question_text]).to be_nil
      expect(session[:question_img]).to be_nil
      expect(session[:question_id]).to be_nil
      expect(session[:try_another_problem]).to be_nil
      expect(session[:is_correct]).to be_nil
      expect(session[:explanation]).to be_nil
    end
  end

  describe 'GET #problem_generation' do
    context 'when reusing question from session' do
      let!(:question) { create(:question, topic_id: topic.topic_id, type_id: type.type_id, question_kind: 'definition', template_text: 'Define something', answer: 'answer') }

      before do
        session[:question_id] = question.id
        session[:question_text] = 'some question text'
        session[:solution] = 'some solution'
        session[:question_img] = 'image.png'
        session[:submitted_answer] = 'answer'
        session[:is_correct] = true
        session[:explanation] = 'explanation'
        session[:round_decimals] = 2
        get :problem_generation
      end

      it 'uses existing session question' do
        expect(assigns(:question)).to eq(question)
        expect(assigns(:question_text)).to eq('some question text')
        expect(assigns(:solution)).to eq('some solution')
      end
    end

    context 'when no questions match' do
      before do
        session[:selected_topic_ids] = ["999"]
        session[:selected_type_ids] = ["999"]
        get :problem_generation
      end

      it 'sets a flash alert' do
        expect(flash[:alert]).to eq("No questions found with the selected topics and types. Please try again.")
      end
    end
  end

  describe 'POST #submit_answer' do
    context 'equation question logic' do
      let!(:question) {
        create(:question, topic_id: topic.topic_id, type_id: type.type_id, question_kind: 'equation', equation: '2 + 2', template_text: 'Q', template_text: 'Template text', variables: ['x'], variable_ranges: [[1, 1]], variable_decimals: [0], round_decimals: 2)
      }

      before do
        session[:question_id] = question.id
        session[:question_kind] = 'equation'
        session[:solution] = '4'
      end

      it 'accepts correct numeric answer' do
        post :submit_answer, params: { answer: '4' }
        expect(session[:is_correct]).to eq(true)
      end

      it 'rejects incorrect answer' do
        post :submit_answer, params: { answer: '5' }
        expect(session[:is_correct]).to eq(false)
      end
    end

    context 'dataset question logic' do
      let!(:question) {
        create(:question, topic_id: topic.topic_id, type_id: type.type_id, question_kind: 'dataset', template_text: 'Data: \( D \)', dataset_generator: '5-5, size=5', answer_strategy: 'mode')
      }

      before do
        session[:question_id] = question.id
        session[:question_kind] = 'dataset'
        session[:solution] = '5'
      end

      it 'accepts correct dataset-derived value' do
        post :submit_answer, params: { answer: '5' }
        expect(session[:is_correct]).to eq(true)
      end

      it 'rejects incorrect dataset value' do
        post :submit_answer, params: { answer: '99' }
        expect(session[:is_correct]).to eq(false)
      end
    end

    context 'definition question logic' do
      let!(:question) {
        create(:question, topic_id: topic.topic_id, type_id: type.type_id, question_kind: 'definition', template_text: 'Define x', answer: 'truth')
      }

      before do
        session[:question_id] = question.id
        session[:question_kind] = 'definition'
        session[:solution] = 'truth'
      end

      it 'is case insensitive' do
        post :submit_answer, params: { answer: 'Truth' }
        expect(session[:is_correct]).to eq(true)
      end

      it 'rejects incorrect answer' do
        post :submit_answer, params: { answer: 'lies' }
        expect(session[:is_correct]).to eq(false)
      end
    end

    context 'unknown question_kind' do
      let!(:question) {
        create(:question, topic_id: topic.topic_id, type_id: type.type_id, template_text: 'Template text', question_kind: 'unknown')
      }

      before do
        session[:question_id] = question.id
        session[:question_kind] = 'unknown'
        session[:solution] = 'anything'
      end

      it 'gracefully marks answer incorrect' do
        post :submit_answer, params: { answer: 'anything' }
        expect(session[:is_correct]).to eq(false)
      end
    end
  end

  describe 'GET #try_another_problem' do
    it 'sets session flag and redirects' do
      get :try_another_problem
      expect(session[:try_another_problem]).to eq(true)
      expect(response).to redirect_to(problem_generation_path)
    end
  end

  describe 'POST #create' do
    it 'stores topic and type ids in session' do
      post :create, params: { topic_ids: ["1"], type_ids: ["1"] }
      expect(session[:selected_topic_ids]).to eq(["1"])
      expect(session[:selected_type_ids]).to eq(["1"])
    end
  end

  describe "#generate_random_values" do
    it "generates correct values with ranges and decimals" do
      variables = ["x", "y"]
      ranges = [[1, 1], [2, 2]]
      decimals = [0, 1]

      controller = ProblemsController.new
      values = controller.send(:generate_random_values, variables, ranges, decimals)

      expect(values[:x]).to eq(1)
      expect(values[:y]).to eq(2.0)
    end

    it "generates default values when no range provided" do
      variables = ["a"]
      controller = ProblemsController.new
      values = controller.send(:generate_random_values, variables)
      expect(values).to have_key(:a)
      expect(values[:a]).to be_between(1, 10)
    end
  end

  describe "#generate_dataset" do
    it "returns correct dataset from generator string" do
      controller = ProblemsController.new
      dataset = controller.send(:generate_dataset, "1-1, size=5")
      expect(dataset).to eq([1, 1, 1, 1, 1])
    end

    it "returns empty array for blank generator" do
      controller = ProblemsController.new
      expect(controller.send(:generate_dataset, nil)).to eq([])
    end
  end

  describe "#compute_dataset_answer" do
    it "computes mean correctly" do
      result = controller.send(:compute_dataset_answer, [1, 2, 3], "mean")
      expect(result).to eq(2.0)
    end

    it "computes median correctly (odd)" do
      result = controller.send(:compute_dataset_answer, [3, 1, 2], "median")
      expect(result).to eq(2)
    end

    it "computes median correctly (even)" do
      result = controller.send(:compute_dataset_answer, [1, 2, 3, 4], "median")
      expect(result).to eq(2.5)
    end

    it "computes mode correctly" do
      result = controller.send(:compute_dataset_answer, [1, 2, 2, 3], "mode")
      expect(result).to eq(2)
    end

    it "returns nil for unknown strategy" do
      result = controller.send(:compute_dataset_answer, [1, 2], "unknown")
      expect(result).to be_nil
    end
  end

  describe "#format_template_text" do
    it "formats text using variable values with decimals" do
      text = "The value is \\( x \\)"
      values = { x: 3.14159 }
      decimals = [2]
      result = controller.send(:format_template_text, text, values, decimals, ["x"])
      expect(result).to eq("The value is 3.14")
    end

    it "returns original if no variables found" do
      result = controller.send(:format_template_text, "Plain text", {})
      expect(result).to eq("Plain text")
    end
  end

  describe "#evaluate_equation" do
    it "correctly evaluates expression" do
      eq = "x + y * z"
      vals = { x: 1, y: 2, z: 3 }
      result = controller.send(:evaluate_equation, eq, vals)
      expect(result).to eq(7.0)
    end

    it "returns nil on bad equation" do
      result = controller.send(:evaluate_equation, "x +", { x: 2 })
      expect(result).to be_nil
    end

    it "returns nil if values are empty" do
      result = controller.send(:evaluate_equation, "x + y", {})
      expect(result).to be_nil
    end
  end

  describe "GET #problem_generation" do
    context "when a matching equation question exists" do
      let!(:equation_question) do
        Question.create!(
          topic_id: 1,
          type_id: 1,
          question_kind: "equation",
          template_text: "What is the final velocity given \\(x\\), \\(a\\), and \\(t\\)?",
          equation: "x + a * t",
          variables: ["x", "a", "t"],
          variable_ranges: [[1, 1], [2, 2], [3, 3]],
          variable_decimals: [0, 0, 0],
          round_decimals: 2,
          explanation: "Use v = x + a*t"
        )
      end

      before do
        session[:selected_topic_ids] = [equation_question.topic_id.to_s]
        session[:selected_type_ids] = [equation_question.type_id.to_s]
        get :problem_generation
      end

      it "assigns a question" do
        expect(assigns(:question)).to eq(equation_question)
      end

      it "stores the question data in session" do
        expect(session[:question_id]).to eq(equation_question.id)
        expect(session[:question_kind]).to eq("equation")
        expect(session[:solution]).to eq(7) # 1 + 2 * 3 from fixed input
      end
    end
  end

  context "when a dataset question is selected" do
    let!(:dataset_question) do
      Question.create!(
        topic_id: 1,
        type_id: 1,
        question_kind: "dataset",
        template_text: "Find the mode of dataset: \\( D \\)",
        dataset_generator: "10-20, size=5",
        answer_strategy: "mode",
        explanation: "Pick the most frequent number."
      )
    end
  
    before do
      session[:selected_topic_ids] = [dataset_question.topic_id.to_s]
      session[:selected_type_ids] = [dataset_question.type_id.to_s]
      allow_any_instance_of(ProblemsController).to receive(:generate_dataset).and_return([10, 12, 12, 14, 15])
      get :problem_generation
    end
  
    it "uses dataset logic and sets dataset-based solution" do
      expect(assigns(:question)).to eq(dataset_question)
      expect(session[:question_kind]).to eq("dataset")
      expect(session[:solution]).to eq(12) # mode of [10,12,12,14,15]
      expect(session[:question_text]).to include("10, 12, 12, 14, 15")
    end
  end

  context "when a definition question is selected" do
    let!(:definition_question) do
      Question.create!(
        topic_id: 1,
        type_id: 1,
        question_kind: "definition",
        template_text: "The force that resists motion between surfaces.",
        answer: "friction",
        explanation: "Friction is a contact force that opposes motion."
      )
    end
  
    before do
      session[:selected_topic_ids] = [definition_question.topic_id.to_s]
      session[:selected_type_ids] = [definition_question.type_id.to_s]
      get :problem_generation
    end
  
    it "uses definition logic and sets the answer directly" do
      expect(assigns(:question)).to eq(definition_question)
      expect(session[:question_kind]).to eq("definition")
      expect(session[:solution]).to eq("friction")
      expect(session[:question_text]).to eq(definition_question.template_text)
    end
  end  
end