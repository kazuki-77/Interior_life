# frozen_string_literal: true

class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    # カレントユーザー(following_idにcurrent-userのidを格納)に紐づいた
    # relationshipを作成しフォロワーidを取得する
    following = current_user.relationships.build(follower_id: params[:user_id])
    following.save
    # request.refererで遷移前のpathに戻る
    # 戻れなかった場合はroot_pathへ飛ばす
    redirect_to request.referer || root_path
  end

  def destroy
    # current_userに紐づいたrelationshipsを取得し、フォロー解除する対象のuser_idを指定する
    following = current_user.relationships.find_by(follower_id: params[:user_id])
    following.destroy
    redirect_to request.referer || root_path
  end
end
