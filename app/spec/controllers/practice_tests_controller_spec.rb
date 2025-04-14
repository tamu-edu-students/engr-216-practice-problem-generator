require 'rails_helper'

RSpec.describe PracticeTestsController, type: :controller do
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
        Question.create!(
            topic_id: 1,
            type_id: 1,
            template_text: "Find the velocity given \( x \), \( a \), and \( t \).",
            equation: "x + a * t",
            variables: [ "x", "a", "t" ]
        )
    end

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

  describe 'GET #practice_test_generation' do
    context 'when a question has round_decimals set' do
      before do
        Question.delete_all # ✅ wipe out unrelated questions

        @rounding_question = Question.create!(
          topic_id: 1,
          type_id: 1,
          template_text: "What is the value of e?",
          equation: "2.71828",
          variables: [],
          explanation: "Value of e",
          round_decimals: 2
        )

        session[:selected_topic_ids] = [ @rounding_question.topic_id.to_s ]
        session[:selected_type_ids] = [ @rounding_question.type_id.to_s ]

        get :practice_test_generation
      end

      it 'rounds the solution according to round_decimals' do
        exam_questions = assigns(:exam_questions)
        expect(exam_questions.first[:solution]).to eq(2.72)
      end
    end

    context 'when generating practice tests' do
      before do
        session[:selected_topic_ids] = [ "1", "2" ]
        session[:selected_type_ids] = [ "1", "3" ]
      end

      it 'fetches the correct topics and question types based on session' do
        get :practice_test_generation

        expect(assigns(:selected_topics).map(&:topic_name)).to include("Velocity", "Acceleration")
        expect(assigns(:selected_types).map(&:type_name)).to include("Definition", "Free Response")
      end

      it 'retrieves a valid question set' do
        get :practice_test_generation
        expect(assigns(:exam_questions)).to be_present
      end

      it 'stores questions in session' do
        get :practice_test_generation
        expect(session[:exam_questions]).not_to be_empty
      end

      context 'when no questions match the criteria' do
        before do
          session[:selected_topic_ids] = [ "99" ]
          session[:selected_type_ids] = [ "99" ]
        end

        it 'redirects to the practice test form' do
          get :practice_test_generation
          expect(response).to redirect_to(practice_test_form_path)
          expect(flash[:alert]).to eq("No questions available for the selected criteria.")
        end
      end
    end

    context 'when admin tries to access practice tests page' do
      let!(:admin) do
        User.create!(first_name: "Admin", last_name: "User", email: "admin@example.com", role: :admin)
      end

      before do
        allow(controller).to receive(:current_user).and_return(admin)
      end

      it 'redirects to the welcome page with an alert' do
        get :practice_test_generation
        expect(response).to redirect_to(admin_path)
        expect(flash[:alert]).to eq("Admin not allowed to access practice test page")
      end
    end
  end

  describe 'POST #submit_practice_test' do
    let!(:user) { User.create!(first_name: "Test", last_name: "User", email: "test@example.com", role: :student) }

    before do
      allow(controller).to receive(:current_user).and_return(user)
      session[:exam_questions] = [
        {
          question_id: question.id,
          question_text: "Find the velocity given position, acceleration, and time.",
          solution: "10"
        }
      ]
    end

    context 'when submitting a correct answer' do
      before do
        post :submit_practice_test, params: { answers: { question.id.to_s => "10" } }
      end

      it 'redirects to the results page' do
        expect(response).to redirect_to(practice_test_result_path)
      end

      it 'records a correct submission' do
        expect(Submission.count).to eq(1)
        submission = Submission.last
        expect(submission.user).to eq(user)
        expect(submission.question).to eq(question)
        expect(submission.correct).to be true
      end

      it 'stores test results in session' do
        expect(session[:test_results][:score]).to eq(1)
        expect(session[:test_results][:total]).to eq(1)
      end
    end

    context 'when submitting an incorrect answer' do
      before do
        post :submit_practice_test, params: { answers: { question.id.to_s => "5" } }
      end

      it 'redirects to the results page' do
        expect(response).to redirect_to(practice_test_result_path)
      end

      it 'records an incorrect submission' do
        expect(Submission.count).to eq(1)
        submission = Submission.last
        expect(submission.user).to eq(user)
        expect(submission.question).to eq(question)
        expect(submission.correct).to be false
      end

      it 'stores test results in session' do
        expect(session[:test_results][:score]).to eq(0)
        expect(session[:test_results][:total]).to eq(1)
      end
    end

    context 'when submitting a text-based answer (case-insensitive)' do
        before do
          session[:exam_questions] = [
            { question_id: question.id, question_text: "What is the capital of France?", solution: "Paris" }
          ]
        end

        it 'accepts correct answers with different letter cases' do
          post :submit_practice_test, params: { answers: { question.id.to_s => "paris" } }

          expect(response).to redirect_to(practice_test_result_path)
          expect(session[:test_results][:results].first[:correct]).to be true
        end

        it 'rejects incorrect answers' do
          post :submit_practice_test, params: { answers: { question.id.to_s => "london" } }

          expect(response).to redirect_to(practice_test_result_path)
          expect(session[:test_results][:results].first[:correct]).to be false
        end
      end

      context 'when submitting a multiple choice answer' do
        let!(:mc_type) { Type.create!(type_id: 4, type_name: "Multiple choice") }
        let!(:mc_question) do
          Question.create!(
            topic_id: 1,
            type: mc_type,
            template_text: "Which unit measures force?"
          )
        end

        let!(:choices) do
          [
            AnswerChoice.create!(question: mc_question, choice_text: "Watts", correct: false),
            AnswerChoice.create!(question: mc_question, choice_text: "Newtons", correct: true),
            AnswerChoice.create!(question: mc_question, choice_text: "Joules", correct: false),
            AnswerChoice.create!(question: mc_question, choice_text: "Amps", correct: false)
          ]
        end

        before do
          session[:exam_questions] = [
            {
              question_id: mc_question.id,
              question_text: mc_question.template_text,
              solution: "Newtons",
              round_decimals: nil,
              explanation: "Force is measured in Newtons.",
              answer_choices: choices.map { |c| { id: c.id, text: c.choice_text } }
            }
          ]
        end

        it 'marks correct when correct multiple choice answer is selected' do
          post :submit_practice_test, params: {
            answers: {
              mc_question.id.to_s => "Newtons"
            }
          }

          expect(response).to redirect_to(practice_test_result_path)
          expect(Submission.count).to eq(1)
          expect(Submission.last.correct).to be true
          expect(session[:test_results][:score]).to eq(1)
        end

        it 'marks incorrect when wrong multiple choice answer is selected' do
          post :submit_practice_test, params: {
            answers: {
              mc_question.id.to_s => "Joules"
            }
          }

          expect(response).to redirect_to(practice_test_result_path)
          expect(Submission.count).to eq(1)
          expect(Submission.last.correct).to be false
          expect(session[:test_results][:score]).to eq(0)
        end
      end
  end

  describe 'GET #result' do
    it 'renders the results page with correct variables' do
      session[:test_results] = {
        score: 1,
        total: 2,
        results: [
          { question_id: 1, question_text: "Q1", submitted_answer: "10", solution: "10", correct: true },
          { question_id: 2, question_text: "Q2", submitted_answer: "5", solution: "15", correct: false }
        ]
      }

      get :result

      expect(response).to render_template(:result)
      expect(assigns(:score)).to eq(1)
      expect(assigns(:total)).to eq(2)
      expect(assigns(:results).size).to eq(2)
    end
  end

  describe "#generate_random_values" do
    let(:variables) { [ "x", "y", "z" ] }

    it 'generates random values for all variables' do
      controller = PracticeTestsController.new
      random_values = controller.send(:generate_random_values, variables)

      expect(random_values.keys).to match_array([ :x, :y, :z ])
      random_values.values.each do |value|
        expect(value).to be_between(1, 10).inclusive
      end
    end
  end

  describe "#format_template_text" do
    let(:template_text) { 'Calculate [x] plus [y]' }
    let(:variables) { { x: 3, y: 7 } }

    it 'formats the template text with given values' do
      controller = PracticeTestsController.new
      formatted_text = controller.send(:format_template_text, template_text, variables)

      expect(formatted_text).to eq("Calculate 3 plus 7")
    end
  end

  describe "#evaluate_equation" do
    let(:equation) { "x + y" }
    let(:values) { { x: 3, y: 7 } }

    it 'evaluates the equation with given values' do
      controller = PracticeTestsController.new
      result = controller.send(:evaluate_equation, equation, values)

      expect(result).to eq(10)
    end

    it 'returns nil when equation has invalid syntax' do
      controller = PracticeTestsController.new
      result = controller.send(:evaluate_equation, "x + y +", values)
      expect(result).to be_nil
    end
  end

  describe "#evaluate_multiple_choice" do
    let(:question_type) { "Multiple choice" }
    let(:answer_choices) do
      [
        { id: 1, text: "Choice 1", correct: false },
        { id: 2, text: "Choice 2", correct: true },
        { id: 3, text: "Choice 3", correct: true }
      ]
    end

    it 'returns true for correct answer' do
      controller = PracticeTestsController.new
      result = controller.send(:evaluate_multiple_choice, question_type, answer_choices, "Choice 2")

      expect(result).to eq([ answer_choices[1], true ])
    end

    it 'returns false for incorrect answer' do
      controller = PracticeTestsController.new
      result = controller.send(:evaluate_multiple_choice, question_type, answer_choices, "Choice 1")

      expect(result).to eq([ answer_choices[1], false ])
    end
    it 'returns nil for invalid question type' do
      controller = PracticeTestsController.new
      result = controller.send(:evaluate_multiple_choice, "Invalid type", answer_choices, "Choice 1")

      expect(result).to eq([ nil, false ])
    end
  end
end
