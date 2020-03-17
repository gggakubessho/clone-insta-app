# frozen_string_literal: true

class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications.paginate(page: params[:page], per_page: 10)
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
end
