require 'rails_helper'

RSpec.describe InstructorHomeController, type: :controller do
  let(:instructor) { create(:user, role: :instructor) }
  let(:student) { create(:user, role: :student) }
  let(:topic) { create(:topic) }
  let(:type) { create(:type) }

  describe 'GET #index' do
    context 'when the user is an instructor' do
      before do
        allow(controller).to receive(:current_user).and_return(instructor)
        get :index
      end

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

    context 'when the user is not an instructor' do
      before do
        allow(controller).to receive(:current_user).and_return(student)
        get :index
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'sets an alert message' do
        expect(flash[:alert]).to eq("You are not authorized to access this page.")
      end
    end

    context 'when the user is not signed in' do
      before do
        allow(controller).to receive(:current_user).and_return(nil)
        get :index
      end

      it 'redirects to the sign-in page' do
        expect(response).to redirect_to(welcome_path)
      end
    end
  end

  describe 'GET #custom_template' do
    context 'when the user is an instructor' do
      before do
        allow(controller).to receive(:current_user).and_return(instructor)
        get :custom_template
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the custom_template template' do
        expect(response).to render_template(:custom_template)
      end
    end

    context 'when the user is not an instructor' do
      before do
        allow(controller).to receive(:current_user).and_return(student)
        get :custom_template
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'sets an alert message' do
        expect(flash[:alert]).to eq("You are not authorized to access this page.")
      end
    end
  end

  describe 'POST #create_template' do
    context 'when the user is an instructor' do
      before do
        allow(controller).to receive(:current_user).and_return(instructor)
      end

      it 'creates a new question template' do
        expect {
          post :create_template, params: {
            topic_id: topic.id,
            type_id: type.id,
            template_text: "Sample template text",
            equation: "a + b",
            variables: "a, b",
            answer: "c"
          }
        }.to change(Question, :count).by(1)
        expect(response).to redirect_to(instructor_home_path)
        expect(flash[:notice]).to eq("Question template created successfully!")
      end
    end

    context 'when the user is not an instructor' do
      before do
        allow(controller).to receive(:current_user).and_return(student)
        post :create_template, params: {
          topic_id: topic.id,
          type_id: type.id,
          template_text: "Sample template text",
          equation: "a + b",
          variables: "a, b",
          answer: "c"
        }
      end

      it 'does not create a new question template' do
        expect(Question.count).to eq(0)
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'sets an alert message' do
        expect(flash[:alert]).to eq("You are not authorized to access this page.")
      end
    end
  end
end
