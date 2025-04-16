require 'rails_helper'

RSpec.describe AdminRolesController, type: :controller do
  let!(:user) { create(:user, email: 'john.doe@tamu.edu', role: :admin) }
  let!(:instructor) { create(:user, email: 'instructor@tamu.edu', role: :instructor) }

  before do
    allow(controller).to receive(:logged_in?).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'assigns @users and @roles' do
        get :index

        # Check that the @users variable contains the correct user
        expect(assigns(:users)).to include(user)
        expect(assigns(:users)).to include(instructor)
        expect(assigns(:roles)).to eq(User.roles.keys)

        # Ensure the index template is rendered
        expect(response).to render_template(:index)
    end

    it 'redirects non-admin users with an alert' do
      allow(controller).to receive(:current_user).and_return(instructor)

      get :index

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("You do not have permission to access this page.")
    end
  end


  describe 'PATCH #update_role' do
    context 'with valid parameters' do
      it 'updates the user role and redirects to admin roles path' do
        patch :update_role, params: { id: user.id, role: 'instructor' }
        user.reload

        expect(user.role).to eq('instructor')
        expect(flash[:notice]).to eq('User role updated successfully.')
        expect(response).to redirect_to(admin_roles_path)
      end
    end

    context 'with a non-existent user' do
      it 'raises an ActiveRecord::RecordNotFound error' do
        expect {
          patch :update_role, params: { id: 99999999, role: 'instructor' }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
