# frozen_string_literal: true

class ImagesController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @image = Image.find_by(id: params[:id])    
    if @image
      respond_to :js
    else
      redirect_to root_path
    end    
  end

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

  def search
    @images = search_comments(params[:search]).map(&:image)
  end

  private

  def image_params
    params.require(:image).permit(:image_url)
  end

  def search_comments(search)
    return Comment.all unless search

    Comment.select(:image_id).distinct.where('content LIKE ?', "%#{search}%")
  end
end
