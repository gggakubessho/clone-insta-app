# frozen_string_literal: true

class User < ApplicationRecord
  has_many :images, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fav_images, through: :favorites, source: :image
  has_many :comments, foreign_key: 'from_user_id', dependent: :destroy, inverse_of: :user
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id',
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id',
                                  dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id',
                                   dependent: :destroy
  has_many :noticed_users, through: :passive_notifications, source: :visited

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

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Image.where("user_id IN (#{following_ids})", user_id: id)
  end

  # お気に入り登録
  def like(fav_image)
    fav_images << fav_image
  end

  # お気に入り解除
  def unlike(fav_image)
    favorites.find_by(image_id: fav_image.id).destroy
  end

  # 対象の投稿がお気に入り登録済ならtrueを返す
  def like?(fav_image)
    fav_images.include?(fav_image)
  end
end
