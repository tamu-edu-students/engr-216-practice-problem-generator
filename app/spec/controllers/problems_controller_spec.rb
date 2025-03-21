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

  let!(:question) { Question.create!(topic_id: 1, type_id: 1, template_text: "What is velocity given position, accelaration, and time?", equation: "v = x + at", variables: [ "x", "a", "t" ]) }


  before do
    allow(controller).to receive(:logged_in?).and_return(true)
  end

  describe 'POST #create' do
    context 'when submitting topics and types' do
        it 'saves the selected topics and question types in session' do
        post :create, params: { topic_ids: [ 1, 2 ], type_ids: [ 1, 3 ] }

        expect(session[:selected_topic_ids]).to eq([ "1", "2" ])
        expect(session[:selected_type_ids]).to eq([ "1", "3" ])
        end

        it 'handles empty selections' do
          post :create, params: { topic_ids: [], type_ids: [] }

          expect(session[:selected_topic_ids]).to eq([])
          expect(session[:selected_type_ids]).to eq([])
        end
    end
  end

  describe "#generate_random_values" do
    let(:variables) { [ "x", "y", "z" ] }

    it 'generates random values for all variables' do
      controller = ProblemsController.new
      random_values = controller.send(:generate_random_values, variables)

      expect(random_values.keys).to match_array([ :x, :y, :z ])
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

      result = controller.send(:evaluate_equation, "x * y + z / f", { x: 2, y: 3, z: 4, f: 2 })
      expect(result).to eq(8)
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

  describe 'GET #problem_form' do
    it 'clears specified session keys' do
      session[:submitted_answer] = "some answer"
      session[:solution] = "solution"
      session[:question_text] = "question text"
      session[:question_img] = "image url"
      session[:question_id] = 123
      session[:try_another_problem] = true
      session[:is_correct] = false
      session[:explanation] = "explanation"

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
    context 'when session[:question_id].present?' do
      let!(:question) do
        Question.create!(
          topic_id: 1,
          type_id: 1,
          template_text: "What is velocity given position, acceleration, and time?",
          equation: "x + a * t",
          variables: [ "x", "a", "t" ],
          explanation: "Velocity is the sum of position and acceleration multiplied by time.",
          round_decimals: 2
        )
      end

      before do
        # Set session variables to simulate a submitted question
        session[:question_id] = question.id
        session[:question_text] = "Stored question text"
        session[:solution] = "Stored solution"
        session[:question_img] = "Stored image"
        session[:submitted_answer] = "Stored submitted answer"
        session[:is_correct] = true
        session[:explanation] = "Stored explanation"
        session[:round_decimals] = 2
        get :problem_generation
      end

      it 'assigns variables from session in the "submit route" block' do
        expect(assigns(:question)).to eq(question)
        expect(assigns(:question_text)).to eq("Stored question text")
        expect(assigns(:solution)).to eq("Stored solution")
        expect(assigns(:question_img)).to eq("Stored image")
        expect(assigns(:submitted_answer)).to eq("Stored submitted answer")
        expect(assigns(:is_correct)).to eq(true)
        expect(assigns(:explanation)).to eq("Stored explanation")
        expect(assigns(:round_decimals)).to eq(2)
      end
    end

    context 'when session[:question_id] is not present' do
      before do
        session[:selected_topic_ids] = [ "1", "2" ]
        session[:selected_type_ids] = [ "1", "3" ]
        get :problem_generation
      end

      it 'assigns a new question when found' do
        expect(assigns(:question)).to be_present
        expect(session[:question_id]).to eq(assigns(:question).id)
      end
    end
  
    context 'when generating problems with selected topics and types' do
      before do
        session[:selected_topic_ids] = [ "1", "2" ]
        session[:selected_type_ids] = [ "1", "3" ]
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

      it 'stores question ID in session' do
        get :problem_generation
        expect(session[:question_id]).to eq(question.id)
      end
    end

    context 'when no questions are found' do
      before do
        session[:selected_topic_ids] = [ "4" ]
        session[:selected_type_ids] = [ "1" ]
      end

      it 'redirects back to the problem form page' do
        get :problem_generation

        expect(assigns(:question)).to be_nil
        expect(flash[:alert]).to eq("No questions found with the selected topics and types. Please try again.")
      end
    end

    context 'when a question has round_decimals set' do
      let!(:rounding_question) do
        Question.create!(
          topic_id: topics.first.id,
          type_id: types.first.id,
          template_text: "What is the value of e?",
          equation: "2.71828",
          variables: [],
          explanation: "Value of e",
          round_decimals: 2
        )
      end

      before do
        allow(controller).to receive(:generate_random_values).and_return({ dummy: 0 })
        session[:selected_topic_ids] = [rounding_question.topic_id.to_s]
        session[:selected_type_ids] = [rounding_question.type_id.to_s]
        get :problem_generation
      end

      it 'rounds the solution according to round_decimals' do
        expect(assigns(:solution)).to eq(2.72)
      end
    end
  end

  describe 'GET #problem_generation with try_another_problem flag' do
    let!(:existing_question) do
      Question.create!(
        topic_id: 1,
        type_id: 1,
        template_text: "What is velocity given position, acceleration, and time?",
        equation: "x + a * t",
        variables: [ "x", "a", "t" ],
        explanation: "Velocity is the sum of position and acceleration multiplied by time."
      )
    end

    before do
      # Set session keys as if a question had been submitted
      session[:question_id] = existing_question.id
      session[:question_text] = "Stored question text"
      session[:solution] = "Stored solution"
      session[:question_img] = "Stored image"
      session[:submitted_answer] = "Stored submitted answer"
      session[:is_correct] = true
      session[:explanation] = "Stored explanation"
      # Set try another flag
      session[:try_another_problem] = true

      get :problem_generation
    end

    it 'deletes session keys when try_another_problem is set' do
      # After get :problem_generation, keys should be cleared.
      expect(session[:question_id]).to be_nil
      expect(session[:question_text]).to be_nil
      expect(session[:solution]).to be_nil
      expect(session[:question_img]).to be_nil
      expect(session[:submitted_answer]).to be_nil
      expect(session[:is_correct]).to be_nil
      expect(session[:explanation]).to be_nil
      # The try_another flag should also be cleared
      expect(session[:try_another_problem]).to be_nil
    end
  end

  describe 'GET #try_another_problem' do
    before do
      get :try_another_problem
    end

    it 'sets session[:try_another_problem] to true' do
      expect(session[:try_another_problem]).to eq(true)
    end

    it 'redirects to the problem_generation page' do
      expect(response).to redirect_to(problem_generation_path)
    end
  end

  describe 'POST #submit_answer' do
    let!(:user) { User.create!(first_name: "Test", last_name: "User", email: "test@example.com", role: :student) }
    let(:question) do
      Question.create!(
        topic_id: 1,
        type_id: 1,
        template_text: "What is velocity given position, acceleration, and time?",
        equation: "x + a * t",
        variables: [ "x", "a", "t" ],
        explanation: "Velocity is the sum of position and acceleration multiplied by time."
      )
    end

    before do
      allow(controller).to receive(:current_user).and_return(user)
      session[:solution] = "11"
      session[:question_text] = "What is velocity given position, acceleration, and time?"
      session[:question_img] = ""
      session[:question_id] = question.id
    end

    context 'when submitting a correct answer' do
      before do
        post :submit_answer, params: { answer: "11" }
      end

      it 'redirects to the problem_generation page with correct data' do
        expect(response).to redirect_to(problem_generation_path)
        expect(session[:is_correct]).to eq(true)
      end

      it 'creates a submission and updates user data' do
        expect(Submission.count).to eq(1)

        submission = Submission.last
        expect(submission.user).to eq(user)
        expect(submission.question).to eq(question)
        expect(submission.correct).to be true

        user.reload
        expect(user.total_submissions).to eq(1)
        expect(user.correct_submissions).to eq(1)
      end
    end

    context 'when submitting an incorrect answer' do
      before do
        post :submit_answer, params: { answer: "12" }
      end

      it 'redirects to the problem_generation page with correct data' do
        expect(response).to redirect_to(problem_generation_path)
        expect(session[:is_correct]).to eq(false)
      end

      it 'creates a submission with correct being false' do
        expect(Submission.count).to eq(1)

        submission = Submission.last
        expect(submission.user).to eq(user)
        expect(submission.question).to eq(question)
        expect(submission.correct).to be false

        user.reload
        expect(user.total_submissions).to eq(1)
        expect(user.correct_submissions).to eq(0)
      end
    end
  end
end
