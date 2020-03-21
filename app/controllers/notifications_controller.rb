# frozen_string_literal: true

class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications.paginate(page: params[:page], per_page: 10)
    @noticed_users = current_user.noticed_users
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
end
