# frozen_string_literal: true

class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    if params[:keyword].present?
      @post_images = PostImage.where(['title LIKE? OR caption LIKE?', "%#{params[:keyword]}%",
                                      "%#{params[:keyword]}%"]).page(params[:page]).reverse_order.per(6)
      @keyword = params[:keyword]
    else
      redirect_to request.referer
    end
  end
end
