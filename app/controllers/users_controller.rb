# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def index; end

  def edit
    @user = current_user
  end

  def update_password
    @user = current_user

    if @user.update_with_password(user_params)
      bypass_sign_in(@user)
      flash[:notice] = 'パスワードが変更されました'
      redirect_to edit_user_path(@user)
    else
      flash.now[:alert] = '変更に失敗しました'
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
