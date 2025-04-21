require 'rails_helper'

RSpec.describe TemplatesController, type: :controller do
  let(:instructor) { User.create!(first_name: "Inst", last_name: "Ructor", email: "inst@example.com", role: :instructor) }
  let(:student) { User.create!(first_name: "Johnny", last_name: "Manziel", email: "tamu@example.com", role: :student) }
  let!(:topic) { Topic.create!(topic_id: 1, topic_name: "Physics") }
  let!(:type)  { Type.create!(type_id: 1, type_name: "Free response") }
  let!(:mc_type)  { Type.create!(type_id: 2, type_name: "Multiple choice") }

  before do
    allow(controller).to receive(:current_user).and_return(instructor)
  end

  describe "GET template forms" do
    it "renders new_equation template" do
      get :new_equation
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new_equation)
    end

    it "renders new_dataset template" do
      get :new_dataset
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new_dataset)
    end

    it "renders new_definition template" do
      get :new_definition
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new_definition)
    end
  end

  describe "POST #create_equation" do
    before do
      calculator = instance_double(Dentaku::Calculator, evaluate!: 2.0)
      allow(Dentaku::Calculator).to receive(:new).and_return(calculator)
    end

    context 'with valid free response input' do
      let(:params) do
        {
          question: {
            topic_id: topic.id,
            type_id: type.id,
            template_text: "Calculate final velocity: [x], [a]",
            equation: "x + a",
            variables: [ "x", "a" ],
            variable_ranges: [ { "min" => "1", "max" => "3" }, { "min" => "1", "max" => "20" } ],
            variable_decimals: [ 0, 0 ],
            explanation: "E",
            round_decimals: 2
          }
        }
      end

      it 'creates an equation question and redirects' do
        expect {
          post :create_equation, params: params
        }.to change(Question, :count).by(1)

        expect(response).to redirect_to(instructor_home_path)
        expect(flash[:notice]).to eq("Equation-based question template created!")
        last = Question.last
        expect(last.topic_id).to eq(topic.id)
        expect(last.type_id).to eq(type.id)
        expect(last.template_text).to eq("Calculate final velocity: [x], [a]")
        expect(last.equation).to eq("x + a")
        expect(last.variables).to eq([ "x", "a" ])
        expect(last.variable_ranges).to eq([ [ 1.0, 3.0 ], [ 1.0, 20.0 ] ])
      end
    end

    context "with invalid equation" do
      let(:invalid_params) do
        {
          question: {
            topic_id: topic.id,
            type_id: type.id,
            template_text: "Calculate final velocity: [x], [a]",
            equation: "x +",
            variables: [ "x" ],
            variable_ranges: [ { "min" => "1", "max" => "3" } ],
            variable_decimals: [ "0" ],
            explanation: "E",
            round_decimals: 2
          }
        }
      end

      before do
        calc = instance_double(Dentaku::Calculator)
        allow(calc).to receive(:evaluate!).and_raise(StandardError.new("Invalid equation"))
        allow(Dentaku::Calculator).to receive(:new).and_return(calc)
      end


      it 'redirects back to the form with an error' do
        post :create_equation, params: invalid_params

        expect(response).to redirect_to(custom_template_equation_path)
        expect(flash[:alert]).to match(/Invalid equation:/)
      end
    end

    context 'with multiple choice selected' do
      let(:params) do
        {
          question: {
            topic_id: topic.id,
            type_id: mc_type.id,
            template_text: "What is 2 + 2",
            explanation: "explanation",
            answer_choices_attributes: {
              "0" => { choice_text: "4", correct: true },
              "1" => { choice_text: "3", correct: false }
            }
          }
        }
      end

      it 'creates a multiple choice question and redirects' do
        expect {
          post :create_equation, params: params
        }.to change(Question, :count).by(1)

        expect(response).to redirect_to(instructor_home_path)
        expect(flash[:notice]).to eq("Equation-based question template created!")
      end
    end

    context 'when the question fails to save' do
      before do
        calc = instance_double(Dentaku::Calculator, evaluate!: 2.0)
        allow(Dentaku::Calculator).to receive(:new).and_return(calc)
      end

      let(:invalid_params) do
        {
          question: {
            topic_id:          topic.id,
            type_id:           type.id,
            template_text:     "",
            equation:          "x + 1",
            variables:         [ "x" ],
            variable_ranges:   [ { "min" => "1", "max" => "2" } ],
            variable_decimals: [ "0" ],
            explanation:       "E",
            round_decimals:    "2"
          }
        }
      end

      it "re-renders the new_equation template with error messages and builds MC slots" do
        post :create_equation, params: invalid_params

        expect(response).to render_template(:new_equation)

        expect(flash.now[:alert]).to match(/Template text can't be blank/)

        q = assigns(:question)
        expect(q.answer_choices.size).to eq(2)
      end
    end
  end

  describe "POST #create_dataset" do
    context "with valid input" do
      let(:valid_params) do
        {
          question: {
            topic_id: topic.id,
            type_id: type.id,
            template_text: "Given data [d], calculate the mean",
            dataset_min: 1,
            dataset_max: 5,
            dataset_size: 10,
            answer_strategy: "mean",
            explanation: "Average"
          }
        }
      end

      it 'builds generator string, creates Question and redirects' do
        expect {
          post :create_dataset, params: valid_params
        }.to change(Question, :count).by(1)

        q = Question.last
        expect(q.dataset_generator).to eq("1-5, size=10")
        expect(q.answer_strategy).to eq("mean")
        expect(response).to redirect_to(instructor_home_path)
        expect(flash[:notice]).to eq("Dataset-based question template created!")
      end
    end

    context "with valid inputs via manual generator" do
      let(:valid_params) do
        {
          question: {
            topic_id:          topic.id,
            type_id:           type.id,
            template_text:     "Data: [D]",
            dataset_generator: "2-8, size=6",
            answer_strategy:   "median",
            explanation:       "Middle value"
          }
        }
      end

      it "uses the manual generator, creates a Question, and redirects" do
        expect {
          post :create_dataset, params: valid_params
        }.to change(Question, :count).by(1)

        expect(Question.last.dataset_generator).to eq("2-8, size=6")
        expect(response).to redirect_to(instructor_home_path)
      end
    end

    context 'when missing generator or strategy' do
      let(:params) do
        {
          question: {
            topic_id:      topic.id,
            type_id:       type.id,
            template_text: "Bad data",
            explanation:   "Oops"
          }
        }
      end

      it "does not create and redirects back with an alert" do
        expect {
          post :create_dataset, params: params
        }.not_to change(Question, :count)

        expect(response).to redirect_to(custom_template_dataset_path)
        expect(flash[:alert]).to eq("Dataset generator and answer type are required.")
      end
    end

    context "when the dataset_generator format is invalid" do
      let(:invalid_params) do
        {
          question: {
            topic_id:          topic.id,
            type_id:           type.id,
            template_text:     "Any text here",
            dataset_generator: "not-a-range",   # this will fail your format validator
            answer_strategy:   "mean",
            explanation:       "Oops"
          }
        }
      end

      it "does not create a Question and renders the new_dataset form with errors" do
        expect {
          post :create_dataset, params: invalid_params
        }.not_to change(Question, :count)

        # it should render, not redirect
        expect(response).to render_template(:new_dataset)

        # the flash.now[:alert] from your else block should be set
        expect(flash[:alert]).to match(/must be in format/)
      end
    end
  end

  describe "POST #create_definition" do
    context "with valid input" do
      let(:valid_params) do
        {
          question: {
            topic_id:      topic.id,
            type_id:       type.id,
            template_text: "Define inertia.",
            answer:        "Resistance to change in motion",
            explanation:   "Physics term"
          }
        }
      end

      it 'creates a Question and redirects' do
        expect {
          post :create_definition, params: valid_params
        }.to change(Question, :count).by(1)

        expect(response).to redirect_to(instructor_home_path)
        q = Question.last
        expect(q.question_kind).to eq("definition")
        expect(q.answer).to eq("Resistance to change in motion")
      end
    end

    context "with valid multiple-choice definition" do
      let(:valid_mc_params) do
        {
          question: {
            topic_id: topic.id,
            type_id: mc_type.id,
            template_text: "What is right",
            explanation: "explanation",
            answer_choices_attributes: {
              "0" => { choice_text: "Mass", correct: true },
              "1" => { choice_text: "Weight", correct: false }
            }
          }
        }
      end

      it "builds the MC choices, creates a Question, and redirects" do
        expect(controller).to receive(:mc_type_selected?).and_call_original

        expect {
          post :create_definition, params: valid_mc_params
        }.to change(Question, :count).by(1)

        expect(response).to redirect_to(instructor_home_path)
        q = Question.last
        expect(q.answer_choices.map(&:choice_text)).to match_array(%w[Mass Weight])
        expect(q.answer_choices.count(&:correct)).to eq(1)
      end
    end

    context "when validation fails" do
      let(:params) do
        {
          question: {
            topic_id:      topic.id,
            type_id:       type.id,
            template_text: "",  # too short
            answer:        ""
          }
        }
      end

      it "does not create and renders with an alert" do
        expect {
          post :create_definition, params: params
        }.not_to change(Question, :count)

        expect(response).to render_template(:new_definition)
        expect(flash.now[:alert]).to match(/can't be blank/)
      end
    end
  end


  context "when current_user is not an instructor or admin" do
    before do
      allow(controller).to receive(:current_user).and_return(student)
    end

    describe "GET template forms" do
      it "redirects from new_equation with alert" do
        get :new_equation
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You are not authorized to access this page.")
      end

      it "redirects from new_dataset with alert" do
        get :new_dataset
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You are not authorized to access this page.")
      end

      it "redirects from new_definition with alert" do
        get :new_definition
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You are not authorized to access this page.")
      end
    end

    describe "POST actions" do
      it "redirects create_equation when unauthorized" do
        post :create_equation, params: {
          topic_id: topic.id,
          type_id: type.id,
          template_text: "Calculate final velocity: [x], [a], [t]",
          equation: "x + a^(2)",
          variables: "x, a",
          variable_ranges: "1-10, 2-5",
          variable_decimals: "0, 0",
          answer: "x + a^2",
          round_decimals: 2,
          explanation: "v = x + a²"
        }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You are not authorized to access this page.")
      end

      it "redirects create_dataset when unauthorized" do
        post :create_dataset, params: {
          topic_id: topic.id,
          type_id: type.id,
          template_text: "Find the mode of [ D ]",
          dataset_generator: "1-10, size=5",
          answer_strategy: "mode",
          explanation: "Find most common"
        }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You are not authorized to access this page.")
      end

      it "redirects create_definition when unauthorized" do
        post :create_definition, params: {
          topic_id: topic.id,
          type_id: type.id,
          template_text: "The force that opposes motion between surfaces.",
          answer: "friction",
          explanation: "Friction is the term"
        }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You are not authorized to access this page.")
      end
    end
  end
end
