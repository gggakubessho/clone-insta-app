# frozen_string_literal: true

class ImagesController < ApplicationController
  before_action :authenticate_user!
  def index; end

  def create
    @image = current_user.images.build(image_params)

    if @image.save
      flash[:success] = 'succeeded upload image'
      redirect_to root_url
    else
      flash.now[:alert] = 'failed upload image'
      render 'home/home'
    end
  end

  def new
    @image = current_user.images
  end

  private

  def image_params
    params.require(:image).permit(:image_url)
  end
end
