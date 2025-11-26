# frozen_string_literal: true

require 'test_helper'

class ListsControllerTest < ActionDispatch::IntegrationTest
  test 'should redirect to login when not signed in' do
    get root_url
    assert_redirected_to new_user_session_path
  end
end
