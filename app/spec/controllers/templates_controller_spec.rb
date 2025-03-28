require 'rails_helper'

RSpec.describe TemplatesController, type: :controller do
  let(:instructor) { User.create!(first_name: "Inst", last_name: "Ructor", email: "inst@example.com", role: :instructor) }
  let!(:topic) { Topic.create!(topic_id: 1, topic_name: "Physics") }
  let!(:type)  { Type.create!(type_id: 1, type_name: "Free Response") }

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
    context "with valid input" do
      it "creates an equation question and redirects" do
        Question.delete_all
        post :create_equation, params: {
          topic_id: topic.id,
          type_id: type.id,
          template_text: "Calculate final velocity: \\(x\\), \\(a\\), \\(t\\)",
          equation: "x + a^(2)",
          variables: "x, a",
          variable_ranges: "1-10, 2-5",
          variable_decimals: "0, 0",
          answer: "x + a^2",
          round_decimals: 2,
          explanation: "v = x + a²"
        }

        expect(Question.last.question_kind).to eq("equation")
        expect(flash[:notice]).to eq("Equation-based question template created!")
        expect(response).to redirect_to(instructor_home_path)
      end
    end

    context "with invalid equation" do
      it "redirects back with error" do
        post :create_equation, params: {
          topic_id: topic.id,
          type_id: type.id,
          template_text: "Bad equation",
          equation: "x + (", # malformed
          variables: "x",
          variable_ranges: "1-10",
          variable_decimals: "0",
          answer: "error",
          round_decimals: 2,
          explanation: "fail"
        }

        expect(flash[:alert]).to match(/Invalid equation/)
        expect(response).to redirect_to(custom_template_equation_path)
      end
    end
  end

  describe "POST #create_dataset" do
    context "with missing fields" do
      it "redirects back with error" do
        post :create_dataset, params: {
          topic_id: topic.id,
          type_id: type.id,
          template_text: "Find the mode of \\( D \\)",
          dataset_generator: "",
          answer_strategy: ""
        }

        expect(flash[:alert]).to eq("Dataset generator and answer type are required.")
        expect(response).to redirect_to(custom_template_dataset_path)
      end
    end

    context "with valid input" do
      it "creates dataset question and redirects" do
        post :create_dataset, params: {
          topic_id: topic.id,
          type_id: type.id,
          template_text: "Find the mode of \\( D \\)",
          dataset_generator: "1-10, size=5",
          answer_strategy: "mode",
          explanation: "Find most common"
        }

        expect(Question.last.question_kind).to eq("dataset")
        expect(response).to redirect_to(instructor_home_path)
      end
    end
  end

  describe "POST #create_definition" do
    context "with missing fields" do
      it "redirects back with error" do
        post :create_definition, params: {
          topic_id: topic.id,
          type_id: type.id,
          template_text: "",
          answer: ""
        }

        expect(flash[:alert]).to eq("Both definition and term are required.")
        expect(response).to redirect_to(custom_template_definition_path)
      end
    end

    context "with valid input" do
      it "creates a definition question and redirects" do
        post :create_definition, params: {
          topic_id: topic.id,
          type_id: type.id,
          template_text: "The force that opposes motion between surfaces.",
          answer: "friction",
          explanation: "Friction is the term"
        }

        expect(Question.last.question_kind).to eq("definition")
        expect(response).to redirect_to(instructor_home_path)
      end
    end
  end
end
