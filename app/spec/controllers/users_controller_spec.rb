require 'rails_helper'
RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:instructor) { create(:user, :instructor) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #show' do
    context 'when the user exists' do
      it 'assigns the requested user to @current_user' do
        get :show, params: { id: user.id }
        expect(assigns(:current_user)).to eq(user)
      end

      it 'returns a successful response' do
        get :show, params: { id: user.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the user does not exist' do
      it 'raises an ActiveRecord::RecordNotFound error' do
        expect {
          get :show, params: { id: -1 }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#full_name' do
    let(:user) { create(:user, first_name: "Philip", last_name: "Ritchey") }

    it 'returns the concatenated full name' do
      expect(user.full_name).to eq("Philip Ritchey")
    end

    it 'handles nil first_name' do
      user.first_name = nil
      expect(user.full_name).to eq(" Ritchey")
    end

    it 'handles nil last_name' do
      user.last_name = nil
      expect(user.full_name).to eq("Philip ")
    end

    it 'handles both first_name and last_name being nil' do
      user.first_name = nil
      user.last_name = nil
      expect(user.full_name).to eq(" ")
    end
  end

  describe 'POST #save_instructor' do
    context 'when a valid instructor is selected' do
      it 'updates the current_user with the selected instructor' do
        post :save_instructor, params: { instructor_id: instructor.id }

        expect(user.reload.instructor_id).to eq(instructor.id)
        expect(flash[:notice]).to eq("Instructor saved successfully!")
        expect(response).to redirect_to(user_path(user.id))
      end
    end

    context 'when an invalid instructor ID is given' do
      it 'does not update the user and sets an error flash message' do
        post :save_instructor, params: { instructor_id: -1 }

        expect(user.reload.instructor_id).to be_nil
        expect(flash[:alert]).to eq("Failed to save instructor.")
        expect(response).to redirect_to(user_path(user.id))
      end
    end
  end
end
