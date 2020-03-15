# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!, only: :show
  def index
    if user_signed_in?
      @feed_items = current_user.feed.paginate(page: params[:page])
    else
      redirect_to new_user_registration_path
    end
  end

  def show; end
end
