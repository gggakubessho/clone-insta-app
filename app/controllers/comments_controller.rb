# frozen_string_literal: true

class CommentsController < ApplicationController
  def show; end

  def create
    @image = Image.find(params[:image_id])
    @comment = @image.comments.build(comment_params)
    @comment.from_user_id = current_user.id
    if @comment.save
      respond_to do |format|
        format.html { redirect_to @image }
        format.js
      end
    else
      redirect_to images_path
    end
  end

  def new; end

  private

  def comment_params
    params.permit(:content)
  end
end
