# frozen_string_literal: true

class PostCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post_image = PostImage.find(params[:post_image_id])
    @post_comment = current_user.post_comments.new(post_comment_params)
    @post_comment.post_image_id = @post_image.id
    @post_comment.save
    # redirect_to post_image_path(@post_image) 非同期化のため、コメントアウト
  end

  def destroy
    @post_image = PostImage.find(params[:post_image_id])
    @post_comment = @post_image.post_comments.find(params[:id])
    @post_comment.destroy
    # redirect_to post_image_path(params[:post_image_id])　非同期化のため、コメントアウト
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
