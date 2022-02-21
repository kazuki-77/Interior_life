# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    # idがcurrent_user以外のユーザーを取得する
    @users = User.where.not(id: current_user.id)
  end

  def show
    @user = User.find(params[:id])
    @post_images = @user.post_images.page(params[:page]).reverse_order.per(4)
  end

  def edit
    @user = User.find(params[:id])
    redirect_to user_path(current_user.id) if @user != current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = 'ユーザー情報を更新しました！'
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  # あるユーザーがフォローしている人全員を取得するアクション
  def followings
    user = User.find(params[:id])
    @users = user.followings
  end

  # あるユーザーをフォローしている人全員を取得するアクション
  def followers
    user = User.find(params[:id])
    @users = user.followers
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end
