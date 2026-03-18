# frozen_string_literal: true

require 'test_helper'

class ListsControllerTest < ActionDispatch::IntegrationTest
  fixtures :users, :lists

  test 'index requires login' do
    get lists_url
    assert_redirected_to new_user_session_path
  end

  test 'index shows for logged in user' do
    sign_in users(:one)
    get lists_url
    assert_response :success
  end

  test 'should create list with valid params when logged in' do
    sign_in users(:one)

    assert_difference('List.count', 1) do
      post lists_url, params: {
        list: { name: '新しい行きたいリスト' }
      }
    end

    assert_redirected_to lists_path
  end

  test 'should not create list with invalid params' do
    sign_in users(:one)

    assert_no_difference('List.count') do
      post lists_url, params: {
        list: { name: '' }
      }
    end

    assert_response :unprocessable_entity
  end
end
