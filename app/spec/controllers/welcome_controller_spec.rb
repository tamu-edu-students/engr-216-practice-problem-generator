require 'rails_helper'
RSpec.describe WelcomeController, type: :controller do
  describe 'GET #index' do
    context 'when the user is logged in' do
      before do
        allow(controller).to receive(:logged_in?).and_return(true)
      end

      it 'redirects to student_home_path with a notice' do
        get :index
        expect(response).to redirect_to(student_home_path)
        expect(flash[:notice]).to eq('Welcome back!')
      end
    end

    context 'when the user is not logged in' do
      before do
        allow(controller).to receive(:logged_in?).and_return(false)
      end

      it 'does not redirect and renders the index template' do
        get :index
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:index)
      end
    end
  end
end
