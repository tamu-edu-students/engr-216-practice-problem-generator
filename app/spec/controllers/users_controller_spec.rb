require 'rails_helper'
RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

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
end
