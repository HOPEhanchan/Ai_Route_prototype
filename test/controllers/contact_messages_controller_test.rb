# frozen_string_literal: true

require 'test_helper'

class ContactMessagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(
      email: 'test@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end

  test 'redirects new when not logged in' do
    get new_contact_messages_url
    assert_redirected_to new_user_session_url
  end

  test 'should get new when logged in' do
    sign_in @user
    get new_contact_messages_url
    assert_response :success
  end

  test 'should create contact_message when logged in' do
    sign_in @user

    assert_difference('ContactMessage.count', 1) do
      post contact_messages_url, params: {
        contact_message: {
          name: 'テスト太郎',
          email: 'test@example.com',
          subject: '問い合わせ',
          body: 'テスト本文'
        }
      }
    end

    assert_response :redirect
  end
end
