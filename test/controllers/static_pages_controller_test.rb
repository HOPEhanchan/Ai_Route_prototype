# frozen_string_literal: true

require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test 'GET /about returns success' do
    get about_path
    assert_response :success
  end
end
