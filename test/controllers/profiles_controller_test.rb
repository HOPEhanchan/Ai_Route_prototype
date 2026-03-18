# frozen_string_literal: true

require 'test_helper'

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  fixtures :users

  test 'redirects to login when not authenticated' do
    get profile_url
    assert_redirected_to new_user_session_path
  end

  test 'shows profile when logged in' do
    sign_in users(:one)
    get profile_url
    assert_response :success
  end

  test 'updates profile with valid params' do
    sign_in users(:one)

    patch profile_url, params: {
      user: { name: '更新後の名前' }
    }

    assert_redirected_to profile_path
    assert_equal '更新後の名前', users(:one).reload.name
  end
end
