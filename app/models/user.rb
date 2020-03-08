# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable, authentication_keys: [:user_name]
  before_save :downcase_email

  VALID_URL_REGEX = /\A#{URI.regexp(%w[http https])}\z/.freeze
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  VALID_TEL_REGEX = /\A\d{10}$|^\d{11}\z/.freeze

  validates :name, presence: true, length: { maximum: 50 }
  validates :user_name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :website, allow_blank: true, format: { with: VALID_URL_REGEX }
  validates :email, allow_blank: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }
  validates :tel, allow_blank: true, format: { with: VALID_TEL_REGEX }

  def downcase_email
    self.email = email.downcase if email.present?
  end

  # user_nameを使用してログインするようオーバーライド
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(['user_name = :value', { value: user_name }]).first
    else
      where(conditions).first
    end
  end

  # ユーザー登録時にemailを不要とする
  def email_required?
    false
  end

  def email_changed?
    false
  end

  # passwordなしでユーザー情報更新
  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end
end
