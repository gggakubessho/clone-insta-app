# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @images = @user.images
  end

  def index; end

  def edit
    @user = current_user
  end

  def update_password
    @user = current_user

    if @user.update_with_password(user_params)
      bypass_sign_in(@user)
      flash[:notice] = 'succeeded change password'
      redirect_to edit_user_path(@user)
    else
      flash.now[:alert] = 'failed change password'
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
