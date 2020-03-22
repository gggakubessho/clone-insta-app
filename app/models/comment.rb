# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :image
  belongs_to :from_user, class_name: 'User'
  has_many :notifications, dependent: :destroy
  validates :from_user_id, presence: true
  validates :image_id, presence: true
end
