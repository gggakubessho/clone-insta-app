# frozen_string_literal: true

class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    respond_to :js
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to :js
  end
end
