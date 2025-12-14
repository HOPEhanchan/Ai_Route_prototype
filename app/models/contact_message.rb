# frozen_string_literal: true

class ContactMessage < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :subject, presence: true, length: { maximum: 100 }
  validates :body, presence: true, length: { maximum: 2000 }
end
