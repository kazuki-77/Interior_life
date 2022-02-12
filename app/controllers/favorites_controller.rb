class FavoritesController < ApplicationController

  def create
    @post_image = PostImage.find(params[:post_image_id])
    # 投稿に紐付け、いいねをする
    favorite = current_user.favorites.new(post_image_id: @post_image.id)
    favorite.save
    # redirect_to request.referer 非同期化のため、コメントアウト
  end

  def destroy
    @post_image = PostImage.find(params[:post_image_id])
    # 投稿に紐づいたいいねを取得する
    favorite = current_user.favorites.find_by(post_image_id: @post_image.id)
    favorite.destroy
    # redirect_to request.referer　非同期化のため、コメントアウト
  end

end
