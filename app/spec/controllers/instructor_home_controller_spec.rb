require 'rails_helper'

RSpec.describe InstructorHomeController, type: :controller do
  let(:instructor) { create(:user, role: :instructor) }
  let(:student) { create(:user, role: :student, instructor_id: instructor.id) }
  let!(:topic) { create(:topic) }
  let!(:type) { create(:type) }
  let(:instructor) { create(:user, role: :instructor) }
  let(:student1) { create(:user, role: :student, instructor_id: instructor.id, total_submissions: 10, correct_submissions: 7) }
  let(:student2) { create(:user, role: :student, instructor_id: instructor.id, total_submissions: 5, correct_submissions: 3) }
  let(:student3) { create(:user, role: :student, instructor_id: instructor.id, total_submissions: 0, correct_submissions: 0) }


  before do
    allow(controller).to receive(:current_user).and_return(instructor)
  end


  describe 'GET #index' do
    context 'when calculating average accuracy' do
      before do
        student1 
        student2 
        student3 
        get :index
      end

      it 'calculates total submissions correctly' do
        total_submissions = student1.total_submissions + student2.total_submissions + student3.total_submissions
        expect(assigns(:students).sum(&:total_submissions)).to eq(total_submissions)
      end

      it 'calculates correct submissions correctly' do
        correct_submissions = student1.correct_submissions + student2.correct_submissions + student3.correct_submissions
        expect(assigns(:students).sum(&:correct_submissions)).to eq(correct_submissions)
      end

      it 'calculates average accuracy correctly' do
        total_submissions = student1.total_submissions + student2.total_submissions + student3.total_submissions
        correct_submissions = student1.correct_submissions + student2.correct_submissions + student3.correct_submissions
        expected_accuracy = if total_submissions > 0
                              ((correct_submissions.to_f / total_submissions) * 100).round(2)
                            else
                              0
                            end
        expect(assigns(:average_accuracy)).to eq(expected_accuracy)
      end
    end
  end


  before do
    allow(controller).to receive(:current_user).and_return(instructor)
  end

  describe 'GET #index' do
    context 'when the user is an instructor' do
      before { get :index }

      it 'returns a successful response' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end

      it 'assigns the current_user as @instructor' do
        expect(assigns(:instructor)).to eq(instructor)
      end
    end

    context 'when the user is not signed in' do
      before do
        allow(controller).to receive(:current_user).and_return(nil)
        get :index
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(welcome_path)
      end
    end
  end

  describe 'GET #summary' do
    context 'when the user is an instructor' do
      let!(:question) { create(:question, topic: topic, type: type) }
      let!(:submission) { create(:submission, user: student, question: question, correct: false) }

      before { get :summary }

      it 'assigns all students' do
        expect(assigns(:students)).to include(student)
      end

      it 'assigns my students' do
        expect(assigns(:my_students)).to include(student)
      end

      it 'assigns the most missed topic' do
        expect(assigns(:most_missed_topic)).to eq(topic)
      end
    end

    context 'when the user is not an instructor' do
      before do
        allow(controller).to receive(:current_user).and_return(student)
        get :summary
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST #select_template_type' do
    it 'redirects to the equation form if selected' do
      post :select_template_type, params: { question_type: "equation" }
      expect(response).to redirect_to(custom_template_equation_path)
    end

    it 'redirects to the dataset form if selected' do
      post :select_template_type, params: { question_type: "dataset" }
      expect(response).to redirect_to(custom_template_dataset_path)
    end

    it 'redirects to the definition form if selected' do
      post :select_template_type, params: { question_type: "definition" }
      expect(response).to redirect_to(custom_template_definition_path)
    end

    it 'redirects back with alert if invalid type' do
      post :select_template_type, params: { question_type: "invalid" }
      expect(response).to redirect_to(new_template_selector_path)
      expect(flash[:alert]).to eq("Please select a valid question type.")
    end
  end
end
