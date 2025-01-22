require 'rails_helper'
RSpec.describe ApplicationController, type: :controller do
  
  let(:user) { create(:user) }

  describe '#current_user' do
    context 'when session[:user_id] is present and valid' do
      it 'returns the user associated with the session user_id' do
        session[:user_id] = user.id
        expect(controller.send(:current_user)).to eq(user)
      end
    end

    context 'when session[:user_id] is present but invalid' do
      it 'returns nil when no user exists with the session user_id' do
        session[:user_id] = -1
        expect(controller.send(:current_user)).to be_nil
      end
    end

    context 'when session[:user_id] is not present' do
      it 'returns nil' do
        session[:user_id] = nil
        expect(controller.send(:current_user)).to be_nil
      end
    end
  end

  describe '#logged_in?' do
    context 'when current_user is present' do
      it 'returns true' do
        allow(controller).to receive(:current_user).and_return(user)
        expect(controller.send(:logged_in?)).to be_truthy
      end
    end

    context 'when current_user is nil' do
      it 'returns false' do
        allow(controller).to receive(:current_user).and_return(nil)
        expect(controller.send(:logged_in?)).to be_falsey
      end
    end
  end

  describe '#require_login' do
    controller do
      def test_action
        render plain: 'Success'
      end
    end

    before do
      routes.draw { get 'test_action' => 'anonymous#test_action' }
    end

    context 'when user is logged in' do
      it 'allows the action to proceed' do
        allow(controller).to receive(:logged_in?).and_return(true)
        get :test_action
        expect(response.body).to eq('Success')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the welcome page with an alert' do
        allow(controller).to receive(:logged_in?).and_return(false)
        get :test_action
        expect(response).to redirect_to(welcome_path)
        expect(flash[:alert]).to eq('You must be logged in to access this section.')
      end
    end
  end
end