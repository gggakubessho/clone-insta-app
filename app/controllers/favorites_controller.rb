# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :authenticate_user!
  def create
    @image = Image.find(params[:image_id])
    current_user.like(@image)
    respond_to do |format|
      format.html { redirect_to @image }
      format.js
    end
  end

  def destroy
    @image = Favorite.find(params[:id]).image
    current_user.unlike(@image)
    respond_to do |format|
      format.html { redirect_to @image }
      format.js
    end
  end
end
