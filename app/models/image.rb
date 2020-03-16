# frozen_string_literal: true

class Image < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :fav_users, through: :favorites, source: :user
  has_many :comments, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  mount_uploader :image_url, ImageUploader
  validates :user_id, presence: true
  validates :image_url, presence: true
end
