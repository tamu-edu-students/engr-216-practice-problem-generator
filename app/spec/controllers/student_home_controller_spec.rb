require 'rails_helper'
RSpec.describe StudentHomeController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }

    before do
      allow(controller).to receive(:current_user).and_return(user)
    end

    it 'assigns @current_user to the current user' do
      get :index
      expect(assigns(:current_user)).to eq(user)
    end

    it 'assigns @profile_path to the user profile path' do
      get :index
      expect(assigns(:profile_path)).to eq(user_path(user))
    end

    it 'assigns @logout_path to the logout path' do
      get :index
      expect(assigns(:logout_path)).to eq(logout_path)
    end

    it 'responds successfully with an HTTP 200 status code' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end
end