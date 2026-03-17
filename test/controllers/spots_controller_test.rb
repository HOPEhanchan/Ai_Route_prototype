# frozen_string_literal: true

require 'test_helper'

class SpotsControllerTest < ActionDispatch::IntegrationTest
  fixtures :users, :tags, :spots, :taggings

  test 'should redirect new when not logged in' do
    get new_spot_path
    assert_redirected_to new_user_session_path
  end

  test 'should get new when logged in' do
    sign_in users(:one)
    get new_spot_path
    assert_response :success
  end

  test 'should create spot with valid params when logged in' do
    sign_in users(:one)

    SpotMetadataFetcher.stub(:call, {
      title: '取得タイトル',
      description: '取得説明',
      image_url: 'https://example.com/image.jpg'
    }) do
      assert_difference('Spot.count', 1) do
        post spots_path, params: {
          spot: {
            title: '新しいスポット',
            url: 'https://example.com/new-spot',
            description: '説明文',
            memo: 'メモ'
          }
        }
      end
    end

    assert_redirected_to spots_path
  end

  test 'should not create spot with invalid params' do
    sign_in users(:one)

    assert_no_difference('Spot.count') do
      post spots_path, params: {
        spot: {
          title: '',
          url: ''
        }
      }
    end

    assert_response :unprocessable_entity
  end
end
