# Mock valid and invalid responses for Google OAuth2
OmniAuth.config.test_mode = true

# Define a helper module for dynamic mock setup
module OmniAuthTestHelpers
  # Mock a valid Google account
  def mock_valid_google_account(email: 'user@tamu.edu', uid: '12345', name: 'TAMU User')
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      provider: 'google_oauth2',
      uid: uid,
      info: {
        name: name,
        email: email,
        first_name: name.split.first,
        last_name: name.split.last
      },
      credentials: {
        token: 'valid_token',
        expires_at: Time.now + 1.hour
      }
    )
  end

  # Mock an invalid Google account
  def mock_invalid_google_account(email: 'user@gmail.com', uid: '54321', name: 'Gmail User')
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      provider: 'google_oauth2',
      uid: uid,
      info: {
        name: name,
        email: email,
        first_name: name.split.first,
        last_name: name.split.last
      },
      credentials: {
        token: 'invalid_token',
        expires_at: Time.now + 1.hour
      }
    )
  end
end

# Include the OmniAuth helpers in Cucumber world
World(OmniAuthTestHelpers)
