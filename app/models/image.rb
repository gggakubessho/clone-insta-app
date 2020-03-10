# frozen_string_literal: true

class Image < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :image_url, ImageUploader
  validates :user_id, presence: true
  validates :image_url, presence: true
end
