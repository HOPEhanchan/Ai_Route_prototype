# frozen_string_literal: true

require "application_system_test_case"

class SignUpTest < ApplicationSystemTestCase
  test "user can sign up" do
    email = "test-#{SecureRandom.hex(4)}@example.com"

    visit new_user_registration_path

    fill_in "user_email", with: email
    fill_in "user_password", with: "password123"
    fill_in "user_password_confirmation", with: "password123"

    # ボタン文言が違っても押せるように「最初のsubmit」を叩く
    first('input[type="submit"], button[type="submit"]').click

    save_screenshot("tmp/screenshots/after_signup.png")

    assert User.exists?(email: email), "Userが作成されていない（登録失敗）"
  end
end
