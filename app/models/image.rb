# frozen_string_literal: true

class Image < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :fav_users, through: :favorites, source: :user
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  mount_uploader :image_url, ImageUploader
  validates :user_id, presence: true
  validates :image_url, presence: true

  def create_notification_like!(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(
      [
        'visitor_id = ? and visited_id = ? and image_id = ? and action = ? ',
        current_user.id, user_id, id, 'like'
      ]
    )
    # いいねされている場合、処理を終了
    return if temp.present?

    notification = current_user.active_notifications.new(
      image_id: id,
      visited_id: user_id,
      action: 'like'
    )
    # 自分の投稿に対するいいねの場合は、通知済みとする
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end

  def create_notification_comment!(current_user, comment_id)
    notification = current_user.active_notifications.new(
      image_id: id,
      comment_id: comment_id,
      visited_id: user_id,
      action: 'comment'
    )
    # 自分の投稿に対するいいねの場合は、通知済みとする
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end
end
