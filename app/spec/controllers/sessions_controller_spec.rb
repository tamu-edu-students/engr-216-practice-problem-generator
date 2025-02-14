require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET #logout' do
    it 'resets the session and redirects to welcome_path with a notice' do
      session[:user_id] = 1
      get :logout
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(welcome_path)
      expect(flash[:notice]).to eq('You are logged out.')
    end
  end

  describe 'GET #omniauth' do
    let(:auth_hash) do
      {
        'provider' => 'google_oauth2',
        'uid' => '12345',
        'info' => {
          'email' => 'user@tamu.edu',
          'name' => 'John Doe'
        }
      }
    end

    before do
      OmniAuth.config.test_mode = true
    end

    context 'when UID and provider are present' do
      context 'with a valid @tamu.edu email' do
        before do
          OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
            provider: 'google_oauth2',
            uid: '12345',
            info: {
              email: 'user@tamu.edu',
              name: 'John Doe',
              first_name: 'John',
              last_name: 'Doe'
            },
            credentials: {
              token: 'valid_token',
              expires_at: Time.now + 1.hour
            },
            extra: {
              raw_info: {
                role: 0
              }
            }
          )
          request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
        end

        it 'creates a new user with student role and redirects to student_home_path' do
          expect {
            get :omniauth
          }.to change(User, :count).by(1)

          user = User.last
          expect(user.role).to eq('student')
          expect(session[:user_id]).to eq(user.id)
          expect(response).to redirect_to(student_home_path)
          expect(flash[:notice]).to eq('You are logged in.')
        end

        it 'creates a new user with instructor role and redirects to instructor_home_path' do
          OmniAuth.config.mock_auth[:google_oauth2][:extra][:raw_info][:role] = 1
          get :omniauth

          user = User.last
          expect(user.role).to eq('instructor')
          expect(session[:user_id]).to eq(user.id)
          expect(response).to redirect_to(instructor_home_path)
          expect(flash[:notice]).to eq('You are logged in.')
        end

        it 'creates a new user with admin role and redirects to admin_path' do
          OmniAuth.config.mock_auth[:google_oauth2][:extra][:raw_info][:role] = 2
          get :omniauth

          user = User.last
          expect(user.role).to eq('admin')
          expect(session[:user_id]).to eq(user.id)
          expect(response).to redirect_to(admin_path)
          expect(flash[:notice]).to eq('You are logged in.')
        end
      end

      context 'with an invalid email domain' do
        before do
          OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
            provider: 'google_oauth2',
            uid: '12345',
            info: {
              email: 'user@gmail.com',
              name: 'John Doe',
              first_name: 'John',
              last_name: 'Doe'
            },
            credentials: {
              token: 'valid_token',
              expires_at: Time.now + 1.hour
            },
            extra: {
              raw_info: {
                role: 0
              }
            }
          )
          request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
        end

        it 'redirects to welcome_path with an alert' do
          get :omniauth
          expect(response).to redirect_to(welcome_path)
          expect(flash[:alert]).to eq('Please login with an @tamu email')
        end
      end
    end

    context 'when UID or provider is missing' do
      before do
        OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
          provider: 'google_oauth2',
          uid: '12345',
          info: {
            email: 'user@tamu.edu',
            name: 'John Doe',
            first_name: 'John',
            last_name: 'Doe'
          },
          credentials: {
            token: 'valid_token',
            expires_at: Time.now + 1.hour
          },
          extra: {
            raw_info: {
              role: 0
            }
          }
        )
        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]

        request.env['omniauth.auth'].delete('uid')
      end

      it 'redirects to welcome_path with an alert' do
        get :omniauth
        expect(response).to redirect_to(welcome_path)
        expect(flash[:alert]).to eq('Authentication failed: Missing UID or provider.')
      end
    end

    context 'when there is an error saving the user' do
      before do
        OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
          provider: 'google_oauth2',
          uid: '12345',
          info: {
            email: 'user@tamu.edu',
            name: 'John Doe',
            first_name: 'John',
            last_name: 'Doe'
          },
          credentials: {
            token: 'valid_token',
            expires_at: Time.now + 1.hour
          },
          extra: {
            raw_info: {
              role: 0
            }
          }
        )
        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
        allow_any_instance_of(User).to receive(:save).and_return(false)
      end

      it 'redirects to welcome_path with an alert' do
        get :omniauth
        expect(response).to redirect_to(welcome_path)
        expect(flash[:alert]).to eq('Error saving user.')
      end
    end
  end
end
