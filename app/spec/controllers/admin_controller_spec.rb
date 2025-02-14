require 'rails_helper'

RSpec.describe AdminController, type: :controller do
  let(:user) { create(:user) }

  before do
    # Simulate a logged-in user
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'assigns the correct instance variables and renders the index template' do
      get :index

      # Check instance variables
      expect(assigns(:admin)).to eq(user)
      expect(assigns(:logout_path)).to eq(logout_path)
      expect(assigns(:profile_path)).to eq(user_path(user))
      expect(assigns(:admin_roles_path)).to eq(admin_roles_path)
      expect(assigns(:student_home_path)).to eq(student_home_path)
      expect(assigns(:instructor_home_path)).to eq(instructor_home_path)

      # Ensure the correct template is rendered
      expect(response).to render_template(:index)
      expect(response).to have_http_status(:ok)
    end
  end
end
