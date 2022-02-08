class SearchesController < ApplicationController

  def search
    @post_images = Post_Image.all
    if params[:keyword].present?
      @post_images = PostImage.where(["title like? OR caption like?", "%#{keyword}%", "%#{keyword}%"])
      @keyword = params[:keyword]
    else
      redirect_to request.referer
    end
  end

end
