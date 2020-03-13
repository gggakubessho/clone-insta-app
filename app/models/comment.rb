# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :image
  belongs_to :from_user, class_name: 'User'
end
