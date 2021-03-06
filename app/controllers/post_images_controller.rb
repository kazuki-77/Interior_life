# frozen_string_literal: true

class PostImagesController < ApplicationController
  before_action :authenticate_user!

  def new
    @post_image = PostImage.new # 空のインスタンスを作成
  end

  def create
    @post_image = PostImage.new(post_image_params) # データを新規登録するためのインスタンスを生成
    @post_image.user_id = current_user.id # ログインユーザーのidを取得し、格納する

    if @post_image.save
      redirect_to post_image_path(@post_image)
    else
      render :new
    end
  end

  def index
    @post_images = PostImage.page(params[:page]).reverse_order.per(6)
  end

  def show
    @post_image = PostImage.find(params[:id])
    @post_comment = PostComment.new
  end

  def destroy
    @post_image = PostImage.find(params[:id])
    @post_image.destroy
    redirect_to post_images_path
  end

  private

  def post_image_params
    params.require(:post_image).permit(:title, :caption, interior_images_images: [])
  end
end
