# frozen_string_literal: true

class ImagesController < ApplicationController
  before_action :authenticate_user!
  def index
    @images = current_user.images.paginate(page: params[:page], per_page: 5)
  end

  def create
    @image = current_user.images.build(image_params)

    if @image.save
      flash[:success] = 'succeeded upload image'
      redirect_to images_path
    else
      flash.now[:alert] = 'failed upload image'
      render new_image_path
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
