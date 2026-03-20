# frozen_string_literal: true

class User < ApplicationRecord
  has_many :lists, dependent: :destroy
  has_many :spots, dependent: :destroy
  has_many :tags, through: :spots

  validates :name, length: { maximum: 50 }, allow_blank: true
  validates :profile, length: { maximum: 300 }, allow_blank: true
  validates :avatar_url, length: { maximum: 255 }, allow_blank: true

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :omniauthable,
         omniauth_providers: [:google_oauth2]

  def admin?
    admin
  end

  def self.from_omniauth(auth)
    user = find_or_initialize_user(auth)
    assign_provider_attributes(user, auth)
    assign_profile_attributes(user, auth)
    user.save!
    user
  end

  def self.find_or_initialize_user(auth)
    find_by(provider: auth.provider, uid: auth.uid) ||
      find_by(email: auth.info.email) ||
      find_or_initialize_by(provider: auth.provider, uid: auth.uid)
  end

  def self.assign_provider_attributes(user, auth)
    user.provider = auth.provider
    user.uid = auth.uid
  end

  def self.assign_profile_attributes(user, auth)
    user.email ||= auth.info.email
    user.name ||= auth.info.name
    user.avatar_url ||= auth.info.image
    user.password ||= Devise.friendly_token[0, 20]
  end

  private_class_method :find_or_initialize_user,
                       :assign_provider_attributes,
                       :assign_profile_attributes
end
