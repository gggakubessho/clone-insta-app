# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :authenticate_user!
  def create
    @image = Image.find(params[:image_id])
    current_user.like(@image)
    @image.create_notification_like!(current_user)
    respond_to :js
  end

  def destroy
    @image = Favorite.find(params[:id]).image
    current_user.unlike(@image)
    respond_to :js
  end
end
