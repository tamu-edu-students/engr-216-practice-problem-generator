require 'rails_helper'

RSpec.describe PracticeController, type: :controller do
  let!(:topic) { create(:topic, topic_id: 1, topic_name: "Velocity") }
  let!(:type) { create(:type, type_id: 1, type_name: "Definition") }
  let!(:user) { create(:user, role: :student) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'POST #create' do
    it 'stores selected topic and type IDs and test mode flag' do
      post :create, params: {
        topic_ids: [ topic.topic_id ],
        type_ids: [ type.type_id ],
        practice_test_mode: '1'
      }

      expect(session[:selected_topic_ids]).to eq([ topic.topic_id.to_s ])
      expect(session[:selected_type_ids]).to eq([ type.type_id.to_s ])
      expect(session[:practice_test_mode]).to eq(true)
    end
  end

  describe 'GET #generation (test mode)' do
    it 'generates test questions and stores them in session' do
      question = create(:question, topic_id: topic.topic_id, type_id: type.type_id, template_text: "Define velocity", answer: "Speed", question_kind: "definition")
      session[:selected_topic_ids] = [ topic.topic_id.to_s ]
      session[:selected_type_ids] = [ type.type_id.to_s ]
      session[:practice_test_mode] = true

      get :generation

      expect(session[:exam_questions]).to be_present
      expect(assigns(:exam_questions).size).to be <= 10
    end
  end

  describe 'GET #generation (single question)' do
    it 'generates a single problem question' do
      question = create(:question, topic_id: topic.topic_id, type_id: type.type_id, template_text: "Define velocity", answer: "Speed", question_kind: "definition")
      session[:selected_topic_ids] = [ topic.topic_id.to_s ]
      session[:selected_type_ids] = [ type.type_id.to_s ]
      session[:practice_test_mode] = false

      get :generation

      expect(assigns(:question)).to eq(question)
      expect(session[:solution]).to eq("Speed")
    end
  end

  describe 'POST #submit_test' do
    let(:question) { create(:question, topic_id: topic.topic_id, type_id: type.type_id, template_text: "Define friction", answer: "friction", question_kind: "definition") }

    before do
      session[:exam_questions] = [
        {
          question_id: question.id,
          question_text: question.template_text,
          solution: "friction",
          question_type: "Definition",
          answer_choices: []
        }
      ]
    end

    it 'records score correctly for correct answer' do
      post :submit_test, params: { answers: { question.id.to_s => "friction" } }
      expect(session[:test_results][:score]).to eq(1)
      expect(response).to redirect_to(practice_result_path)
    end

    it 'records score correctly for incorrect answer' do
      post :submit_test, params: { answers: { question.id.to_s => "drag" } }
      expect(session[:test_results][:score]).to eq(0)
      expect(response).to redirect_to(practice_result_path)
    end

    it 'evaluates numeric answer with tolerance for non-multiple choice' do
        question = create(:question, topic: topic, type: type, template_text: "2 + 2", answer: "4.0", question_kind: "equation")

        session[:exam_questions] = [
          {
            question_id: question.id,
            question_text: question.template_text,
            solution: "4.0",
            question_type: "Equation",
            answer_choices: []
          }
        ]

        post :submit_test, params: { answers: { question.id.to_s => "4.0000001" } }

        expect(session[:test_results][:score]).to eq(1)
      end

      it 'calls evaluate_multiple_choice when question_type is Multiple choice' do
        mc_question = create(:question,
          topic: topic,
          type: type,
          template_text: 'Pick one',
          question_kind: 'multiple_choice'
        )

        session[:exam_questions] = [
          {
            question_id: mc_question.id,
            question_text: mc_question.template_text,
            solution: 'Correct',
            question_type: 'Multiple choice',
            answer_choices: [
              { id: 1, text: 'Correct', correct: true },
              { id: 2, text: 'Wrong', correct: false }
            ]
          }
        ]

        post :submit_test, params: { answers: { mc_question.id.to_s => 'Correct' } }

        expect(session[:test_results]).to be_present
      end
  end

  describe 'GET #try_another' do
    it 'clears single-question session and redirects' do
      session[:question_id] = 123
      session[:practice_test_mode] = false

      get :try_another
      expect(session[:question_id]).to be_nil
      expect(response).to redirect_to(generation_path)
    end
  end

  describe 'GET #retake_exam' do
    it 'resets test data and redirects to new generation' do
      session[:exam_questions] = [ { question_id: 1 } ]
      session[:test_results] = { score: 1 }
      session[:practice_test_mode] = false

      get :retake_exam
      expect(session[:exam_questions]).to be_nil
      expect(session[:test_results]).to be_nil
      expect(session[:practice_test_mode]).to eq(true)
      expect(response).to redirect_to(generation_path)
    end
  end

  describe 'GET #result' do
    it 'assigns test results correctly' do
      session[:test_results] = {
        score: 1,
        total: 2,
        results: [
          { question_id: 1, question_text: "Q1", submitted_answer: "4", solution: "4", correct: true }
        ]
      }

      get :result
      expect(assigns(:score)).to eq(1)
      expect(assigns(:total)).to eq(2)
      expect(assigns(:results).size).to eq(1)
    end
  end

  describe 'POST #submit_answer' do
  let!(:question) do
    create(:question, topic_id: topic.topic_id, type_id: type.type_id,
           template_text: 'Define friction', answer: 'friction', question_kind: 'definition')
  end

  before do
    session[:question_id] = question.id
    session[:solution] = 'friction'
    session[:question_text] = question.template_text
    session[:question_kind] = 'definition'
  end

  it 'marks answer correct for matching definition (case-insensitive)' do
    post :submit_answer, params: { answer: 'Friction' }
    expect(assigns(:is_correct)).to be true
    expect(Submission.last.correct).to be true
  end

  it 'marks answer incorrect for wrong text' do
    post :submit_answer, params: { answer: 'drag' }
    expect(assigns(:is_correct)).to be false
  end

  it 'marks answer incorrect for blank input' do
    post :submit_answer, params: { answer: '' }
    expect(assigns(:submitted_answer)).to eq('[No answer provided]')
    expect(assigns(:is_correct)).to be false
  end

  context 'when question kind is equation' do
    let!(:eq_question) do
      create(:question, topic_id: topic.topic_id, type_id: type.type_id,
             equation: '2 + 2', question_kind: 'equation', template_text: '2 + 2', answer: nil)
    end

    before do
      session[:question_id] = eq_question.id
      session[:solution] = '4'
      session[:question_kind] = 'equation'
    end

    it 'accepts numeric match for equation' do
      post :submit_answer, params: { answer: '4' }
      expect(assigns(:is_correct)).to be true
    end

    it 'rejects wrong numeric answer' do
      post :submit_answer, params: { answer: '5' }
      expect(assigns(:is_correct)).to be false
    end
  end

  context 'when question kind is dataset' do
    let!(:ds_question) do
      create(:question, topic_id: topic.topic_id, type_id: type.type_id,
             question_kind: 'dataset', template_text: 'Pick value', answer_strategy: 'mode')
    end

    before do
      session[:question_id] = ds_question.id
      session[:solution] = '10'
      session[:question_kind] = 'dataset'
    end

    it 'accepts correct dataset answer' do
      post :submit_answer, params: { answer: '10' }
      expect(assigns(:is_correct)).to be true
    end
  end

  context 'when question kind is unknown' do
    before do
      session[:question_kind] = 'foobar'
    end

    it 'defaults to incorrect' do
      post :submit_answer, params: { answer: 'anything' }
      expect(assigns(:is_correct)).to be false
    end
  end

  context 'when multiple choice' do
    let!(:mc_type) { create(:type, type_id: 2, type_name: 'Multiple choice') }
    let!(:mc_question) do
      q = create(:question, topic_id: topic.topic_id, type_id: mc_type.type_id,
                  question_kind: 'multiple_choice', template_text: 'Choose one')
      AnswerChoice.create!(question: q, choice_text: 'Correct', correct: true)
      AnswerChoice.create!(question: q, choice_text: 'Wrong', correct: false)
      q
    end

    before do
      session[:question_id] = mc_question.id
      session[:solution] = 'Correct'
      session[:question_text] = mc_question.template_text
      session[:question_kind] = 'multiple_choice'
    end

    it 'marks correct answer properly' do
      correct_choice = mc_question.answer_choices.find_by(correct: true)
      post :submit_answer, params: { answer_choice_id: correct_choice.id }
      expect(assigns(:is_correct)).to be true
      expect(assigns(:submitted_answer)).to eq('Correct')
      expect(assigns(:answer_choices)).to be_present
    end

    it 'marks incorrect choice properly' do
      wrong_choice = mc_question.answer_choices.find_by(correct: false)
      post :submit_answer, params: { answer_choice_id: wrong_choice.id }
      expect(assigns(:is_correct)).to be false
    end

    it 'handles no answer selected' do
      post :submit_answer, params: { answer_choice_id: 9999 }
      expect(assigns(:submitted_answer)).to eq('[No answer selected]')
      expect(assigns(:is_correct)).to be false
    end
  end
end

describe 'GET #generation (handle_practice_test_generation)' do
  before do
    session[:selected_topic_ids] = [ topic.topic_id.to_s ]
    session[:selected_type_ids] = [ type.type_id.to_s ]
    session[:practice_test_mode] = true
  end

  it 'redirects when no questions found' do
    get :generation
    expect(response).to redirect_to(practice_form_path)
    expect(flash[:alert]).to eq("No questions available for the selected criteria.")
  end

  it 'builds exam question for definition' do
    create(:question, topic_id: topic.topic_id, type_id: type.type_id, question_kind: 'definition', template_text: 'Define mass', answer: 'Resistance to acceleration')

    get :generation
    expect(session[:exam_questions].first[:question_text]).to eq("Define mass")
    expect(session[:exam_questions].first[:solution]).to eq("Resistance to acceleration")
  end

  it 'builds exam question for equation with rounding' do
    create(:question,
      topic_id: topic.topic_id,
      type_id: type.type_id,
      question_kind: 'equation',
      template_text: 'What is [x] + [y]?',
      equation: 'x + y',
      variables: [ 'x', 'y' ],
      variable_ranges: [ [ 1, 1 ], [ 2, 2 ] ],
      variable_decimals: [ 0, 0 ],
      round_decimals: 2
    )

    get :generation
    q = session[:exam_questions].first
    expect(q[:question_text]).to include("1")
    expect(q[:solution]).to eq(3.0)
  end

  it 'builds exam question for dataset' do
    create(:question,
      topic_id: topic.topic_id,
      type_id: type.type_id,
      question_kind: 'dataset',
      template_text: 'Find mode: [D]',
      dataset_generator: '10-10, size=5',
      answer_strategy: 'mode'
    )

    allow_any_instance_of(PracticeController).to receive(:generate_dataset).and_return([ 10, 10, 10, 10, 10 ])
    get :generation

    q = session[:exam_questions].first
    expect(q[:question_text]).to include("10, 10, 10, 10, 10")
    expect(q[:solution]).to eq(10)
  end

  it 'handles unknown question_kind' do
    create(:question,
      topic_id: topic.topic_id,
      type_id: type.type_id,
      question_kind: 'unknown',
      template_text: 'Fallback text',
      answer: 'fallback answer'
    )

    get :generation

    q = session[:exam_questions].first
    expect(q[:question_text]).to eq('Fallback text')
    expect(q[:solution]).to eq('fallback answer')
  end

  it 'includes answer choices for multiple choice' do
    mc_type = create(:type, type_id: 2, type_name: 'Multiple choice')

    question = create(:question,
      topic: topic,
      type: mc_type,
      question_kind: 'multiple_choice',
      template_text: 'Pick one'
    )

    correct_choice = AnswerChoice.create!(question: question, choice_text: 'B', correct: true)
    AnswerChoice.create!(question: question, choice_text: 'A', correct: false)

    question.reload
    session[:selected_topic_ids] = [ topic.topic_id.to_s ]
    session[:selected_type_ids] = [ mc_type.type_id.to_s ]
    session[:practice_test_mode] = true

    get :generation

    q = session[:exam_questions].first
    expect(q[:answer_choices].size).to eq(2)
    expect(q[:solution]).to be_nil
  end
end

describe 'GET #generation (handle_problem_generation)' do
  before do
    session[:selected_topic_ids] = [ topic.topic_id.to_s ]
    session[:selected_type_ids] = [ type.type_id.to_s ]
    session[:practice_test_mode] = false
  end

  it 'clears session when try_another_problem is set' do
    session[:try_another_problem] = true
    session[:submitted_answer] = 'old'
    session[:question_id] = 1

    get :generation
    expect(session[:submitted_answer]).to be_nil
    expect(session[:try_another_problem]).to be_nil
  end

  it 'uses cached question if present' do
    question = create(:question, topic: topic, type: type, template_text: 'Cached question', answer: 'Cached', question_kind: 'definition')
    session[:question_id] = question.id
    session[:question_text] = 'Cached question'
    session[:solution] = 'Cached'

    get :generation
    expect(assigns(:question)).to eq(question)
    expect(assigns(:question_text)).to eq('Cached question')
    expect(assigns(:solution)).to eq('Cached')
  end

  it 'sets up an equation question with rounding' do
    question = create(:question,
      topic: topic,
      type: type,
      question_kind: 'equation',
      template_text: 'What is [x] + [y]?',
      equation: 'x + y',
      variables: [ 'x', 'y' ],
      variable_ranges: [ [ 1, 1 ], [ 2, 2 ] ],
      variable_decimals: [ 0, 0 ],
      round_decimals: 2
    )

    get :generation
    expect(assigns(:question)).to eq(question)
    expect(session[:solution]).to eq(3.0)
    expect(assigns(:question_text)).to include('1', '2')
  end

  it 'sets up a dataset question and computes solution' do
    question = create(:question,
      topic: topic,
      type: type,
      question_kind: 'dataset',
      template_text: 'Find mode: [D]',
      dataset_generator: '5-5, size=5',
      answer_strategy: 'mode'
    )

    allow_any_instance_of(PracticeController).to receive(:generate_dataset).and_return([ 5, 5, 5, 5, 5 ])

    get :generation
    expect(assigns(:question)).to eq(question)
    expect(assigns(:question_text)).to include("5, 5, 5, 5, 5")
    expect(session[:solution]).to eq(5)
  end

  it 'sets up a definition question' do
    question = create(:question,
      topic: topic,
      type: type,
      question_kind: 'definition',
      template_text: 'Define velocity',
      answer: 'Speed in direction'
    )

    get :generation
    expect(assigns(:question_text)).to eq('Define velocity')
    expect(session[:solution]).to eq('Speed in direction')
  end

  it 'sets up a multiple choice question and finds correct choice' do
    mc_type = Type.find_or_create_by!(type_name: 'Multiple choice') do |t|
      t.type_id = Type.maximum(:type_id).to_i + 1
    end

    physics_topic = Topic.find_or_create_by!(topic_name: 'Physics') do |t|
      t.topic_id = Topic.maximum(:topic_id).to_i + 1
    end

    question = create(:question,
      topic: physics_topic,
      type: mc_type,
      question_kind: 'multiple_choice',
      template_text: 'Pick one'
    )

    correct = create(:answer_choice, question: question, choice_text: 'Correct', correct: true)
    create(:answer_choice, question: question, choice_text: 'Wrong', correct: false)

    session[:selected_topic_ids] = [ physics_topic.topic_id.to_s ]
    session[:selected_type_ids] = [ mc_type.type_id.to_s ]
    session[:practice_test_mode] = false

    get :generation

    expect(assigns(:question)).not_to be_nil
    expect(assigns(:question).id).to eq(question.id)
    expect(session[:solution]).to eq('Correct')
    expect(session[:question_text]).to eq('Pick one')

    choices = assigns(:answer_choices)
    expect(choices.map { |c| c[:text] }).to include('Correct', 'Wrong')
    expect(choices.find { |c| c[:correct] }[:text]).to eq('Correct')
  end

  it 'shows flash when no matching question exists' do
    session[:selected_topic_ids] = [ '9999' ]
    session[:selected_type_ids] = [ '9999' ]

    get :generation
    expect(flash[:alert]).to eq("No questions found with the selected topics and types. Please try again.")
  end

  it 'deletes :question_id if it points to a nonexistent question' do
    session[:question_id] = 999999
    session[:selected_topic_ids] = [ topic.topic_id.to_s ]
    session[:selected_type_ids] = [ type.type_id.to_s ]
    session[:practice_test_mode] = false

    get :generation

    expect(session[:question_id]).to be_nil
  end
end

describe '#evaluate_multiple_choice' do
  let(:controller_instance) { PracticeController.new }

  let(:answer_choices) do
    [
      { text: 'A', correct: false },
      { text: 'B', correct: true },
      { text: 'C', correct: false }
    ]
  end

  it 'returns true for correct submitted answer' do
    correct_choice, is_correct = controller_instance.send(:evaluate_multiple_choice, answer_choices, 'B')
    expect(correct_choice[:text]).to eq('B')
    expect(is_correct).to be true
  end

  it 'returns false for incorrect submitted answer' do
    _, is_correct = controller_instance.send(:evaluate_multiple_choice, answer_choices, 'A')
    expect(is_correct).to be false
  end

  it 'returns nil if no correct choice is present' do
    invalid_choices = [
      { text: 'X', correct: false },
      { text: 'Y', correct: false }
    ]
    correct_choice, is_correct = controller_instance.send(:evaluate_multiple_choice, invalid_choices, 'X')
    expect(correct_choice).to be_nil
    expect(is_correct).to be_nil
  end
end

describe '#generate_random_values' do
  let(:controller_instance) { PracticeController.new }

  it 'falls back to default random range when ranges and decimals are nil' do
    result = controller_instance.send(:generate_random_values, [ 'x' ])
    expect(result).to have_key(:x)
    expect(result[:x]).to be_between(1, 10)
  end
end

describe '#evaluate_equation' do
  let(:controller_instance) { PracticeController.new }

  it 'returns nil if the equation is nil' do
    result = controller_instance.send(:evaluate_equation, nil, {})
    expect(result).to be_nil
  end

  it 'returns nil if the equation has invalid syntax' do
    result = controller_instance.send(:evaluate_equation, 'x + ', { x: 1 })
    expect(result).to be_nil
  end

  it 'returns nil if result is infinite' do
    result = controller_instance.send(:evaluate_equation, '1 / 0.0', {})
    expect(result).to be_nil
  end

  it 'evaluates valid expression correctly' do
    result = controller_instance.send(:evaluate_equation, 'x + y', { x: 2, y: 3 })
    expect(result).to eq(5)
  end
end

describe '#generate_dataset' do
  let(:controller_instance) { PracticeController.new }

  it 'returns empty array if generator is blank' do
    result = controller_instance.send(:generate_dataset, '')
    expect(result).to eq([])
  end

  it 'generates dataset with specified range and size' do
    result = controller_instance.send(:generate_dataset, '1-3, size=5')
    expect(result.length).to eq(5)
    expect(result).to all(be_between(1, 3))
  end

  it 'parses generator string correctly' do
    dataset = controller_instance.send(:generate_dataset, '10-10, size=3')
    expect(dataset).to eq([ 10, 10, 10 ])
  end

  it 'returns integers even if range has same min/max' do
    result = controller_instance.send(:generate_dataset, '7-7, size=4')
    expect(result).to eq([ 7, 7, 7, 7 ])
  end
end

describe '#compute_dataset_answer' do
  let(:controller_instance) { PracticeController.new }

  it 'returns nil for blank dataset' do
    result = controller_instance.send(:compute_dataset_answer, [], 'mean')
    expect(result).to be_nil
  end

  it 'calculates mean correctly' do
    result = controller_instance.send(:compute_dataset_answer, [ 2, 4, 6 ], 'mean')
    expect(result).to eq(4.0)
  end

  it 'calculates median for odd-sized dataset' do
    result = controller_instance.send(:compute_dataset_answer, [ 3, 1, 2 ], 'median')
    expect(result).to eq(2)
  end

  it 'calculates median for even-sized dataset' do
    result = controller_instance.send(:compute_dataset_answer, [ 1, 2, 3, 4 ], 'median')
    expect(result).to eq(2.5)
  end

  it 'calculates mode correctly' do
    result = controller_instance.send(:compute_dataset_answer, [ 1, 2, 2, 3 ], 'mode')
    expect(result).to eq(2)
  end

  it 'calculates range correctly' do
    result = controller_instance.send(:compute_dataset_answer, [ 10, 20, 30 ], 'range')
    expect(result).to eq(20)
  end

  it 'calculates standard deviation correctly' do
    result = controller_instance.send(:compute_dataset_answer, [ 2, 4, 4, 4, 5, 5, 7, 9 ], 'standard_deviation')
    expect(result).to eq(2.0)
  end

  it 'calculates variance correctly' do
    result = controller_instance.send(:compute_dataset_answer, [ 2, 4, 4, 4, 5, 5, 7, 9 ], 'variance')
    expect(result).to eq(4.0)
  end

  it 'returns nil for unknown strategy' do
    result = controller_instance.send(:compute_dataset_answer, [ 1, 2, 3 ], 'unknown')
    expect(result).to be_nil
  end
end

describe '#clear_session_data' do
  controller(PracticeController) do
    def clear_test
      clear_session_data
      head :ok
    end
  end

  before do
    routes.draw { get 'clear_test' => 'practice#clear_test' }

    %i[
      submitted_answer solution question_text question_img question_id
      try_another_problem is_correct explanation round_decimals question_kind
      exam_questions test_results practice_test_mode
    ].each { |key| session[key] = "test_#{key}" }
  end

  it 'clears all relevant session keys' do
    get :clear_test
    %i[
      submitted_answer solution question_text question_img question_id
      try_another_problem is_correct explanation round_decimals question_kind
      exam_questions test_results practice_test_mode
    ].each do |key|
      expect(session[key]).to be_nil
    end
  end
end

describe 'GET #form' do
  before do
    %i[
      submitted_answer solution question_text question_img question_id
      try_another_problem is_correct explanation round_decimals question_kind
      exam_questions test_results practice_test_mode
    ].each { |key| session[key] = "test_#{key}" }
  end

  it 'clears all relevant session keys' do
    get :form
    %i[
      submitted_answer solution question_text question_img question_id
      try_another_problem is_correct explanation round_decimals question_kind
      exam_questions test_results practice_test_mode
    ].each do |key|
      expect(session[key]).to be_nil
    end
  end
end
end
