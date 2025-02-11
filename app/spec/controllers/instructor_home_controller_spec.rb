require 'rails_helper'

RSpec.describe InstructorHomeController, type: :controller do
  let(:instructor) { create(:user, role: :instructor) }
  let(:student) { create(:user, role: :student) }

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

    context 'when the user is not signed in' do
      before do
        get :index
      end

      it 'redirects to the sign-in page' do
        expect(response).to redirect_to(welcome_path)
      end
    end
  end
end
