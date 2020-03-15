# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find_by(id: params[:id])
    if @user
      @images = @user.images
    else
      redirect_to root_path
    end
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

  def following
    @title = 'Following'
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
