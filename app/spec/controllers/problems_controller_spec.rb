# spec/controllers/problems_controller_spec.rb
require 'rails_helper'

RSpec.describe ProblemsController, type: :controller do
  let!(:topics) do
    [
      Topic.create!(topic_id: 1, topic_name: "Velocity"),
      Topic.create!(topic_id: 2, topic_name: "Acceleration"),
      Topic.create!(topic_id: 3, topic_name: "Equations of motion")
    ]
  end

  let!(:types) do
    [
      Type.create!(type_id: 1, type_name: "Definition"),
      Type.create!(type_id: 2, type_name: "Multiple Choice"),
      Type.create!(type_id: 3, type_name: "Free Response")
    ]
  end

  let!(:question) do
    [
      Question.create!(topic_id: 1, type_id: 1, template_text: "What is velocity given position, accelaration, and time?", equation: "v = x + at", variables: ["x", "a", "t"]),
    ]
  end

  before do
    allow(controller).to receive(:logged_in?).and_return(true)
  end

  describe 'POST #create' do
    context 'when submitting topics and types' do
        it 'saves the selected topics and question types in session' do
        post :create, params: { topic_ids: [1, 2], type_ids: [1, 3] }
        
        expect(session[:selected_topic_ids]).to eq(["1", "2"])
        expect(session[:selected_type_ids]).to eq(["1", "3"])
        end

        it 'handles empty selections' do
          post :create, params: { topic_ids: [], type_ids: [] }

          expect(session[:selected_topic_ids]).to eq([])
          expect(session[:selected_type_ids]).to eq([])
        end
    end
  end

  describe "#generate_random_values" do
    let(:variables) { ["x", "y", "z"] }

    it 'generates random values for all variables' do
      controller = ProblemsController.new
      random_values = controller.send(:generate_random_values, variables)

      expect(random_values.keys).to match_array([:x, :y, :z])
      random_values.values.each do |value|
        expect(value).to be_between(1, 10).inclusive
      end
    end
  end

  describe "#format_template_text" do
    let(:template_text) { 'Find the sum of the three values \( x \), \( y \), \( z \)' }
    let(:variables) { { x: 1, y: 2, z: 3 } }

    it 'formats the template text with given values' do
      controller = ProblemsController.new
      formatted_text = controller.send(:format_template_text, template_text, variables)

      expect(formatted_text).to eq("Find the sum of the three values 1, 2, 3")
    end
  end

  describe "#evaluate_equation" do
    let(:equation) { "x + y + z" }
    let(:values) { { x: 1, y: 2, z: 3 } }

    it 'evaluates the equation with given values' do
      controller = ProblemsController.new
      result = controller.send(:evaluate_equation, equation, values)

      expect(result).to eq(6)
    end

    it 'returns nil when equation has invalid syntax' do
      controller = ProblemsController.new
      result = controller.send(:evaluate_equation, "x + y + z +", values)
      expect(result).to be_nil
    end

    it 'returns nil when values are empty' do
      controller = ProblemsController.new
      result = controller.send(:evaluate_equation, equation, {})
      expect(result).to be_nil
    end

    it 'returns nil when equation is empty' do
      controller = ProblemsController.new
      result = controller.send(:evaluate_equation, "", values)
      expect(result).to be_nil
    end

    it 'handles missing variables' do
      incomplete_values = { x: 1, y: 2 }
      controller = ProblemsController.new
      result = controller.send(:evaluate_equation, equation, incomplete_values)

      expect(result).to be_nil
    end

    it 'handles division by zero' do
      equation_divbyzero = "x / y"
      values_divbyzero = { x: 1, y: 0 }
      controller = ProblemsController.new
      result = controller.send(:evaluate_equation, equation_divbyzero, values_divbyzero)

      expect(result).to be_nil
    end
  end

  describe 'GET #problem_generation' do
    context 'when generating problems with selected topics and types' do
      before do
        session[:selected_topic_ids] = ["1", "2"]
        session[:selected_type_ids] = ["1", "3"]
      end

      it 'fetches the correct topics and question types based on session' do
        get :problem_generation
        
        expect(assigns(:selected_topics).map(&:topic_name)).to include("Velocity", "Acceleration")
        expect(assigns(:selected_types).map(&:type_name)).to include("Definition", "Free Response")
      end

      it 'retrieves a valid question' do
        get :problem_generation
        expect(assigns(:question)).to be_present
      end
    end

    context 'when no questions are found' do
      before do
        session[:selected_topic_ids] = ["4"]
        session[:selected_type_ids] = ["1"]
      end

      it 'redirects back to the problem form page' do
        get :problem_generation

        expect(assigns(:question)).to be_nil
        expect(flash[:alert]).to eq("No questions found with the selected topics and types. Please try again.")
      end
    end

  end
end