class PostImage < ApplicationRecord

  belongs_to :user
  attachment :image #_idは含めない

  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  def favorited_by?(user)
    # whereメソッドの引数で渡されたユーザーidがFavoritesテーブルに存在(exists?)するかどうかを調べる
    favorites.where(user_id: user.id).exists?
  end
end
