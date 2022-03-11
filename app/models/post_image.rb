# frozen_string_literal: true

class PostImage < ApplicationRecord
  belongs_to :user

  has_many :interior_images, dependent: :destroy
  accepts_attachments_for :interior_images, attachment: :image

  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :title, presence: true
  validates :caption, presence: true, length: { maximum: 200 }
  # validates :image, presence: { message: 'を選択してください'}

  def favorited_by?(user)
    # whereメソッドの引数で渡されたユーザーidがFavoritesテーブルに存在(exists?)するかどうかを調べる
    favorites.where(user_id: user.id).exists?
  end
end
