class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attachment :profile_image, destroy: false

  validates :name, length: {maximum: 20, minimum: 2}, uniqueness: true

  has_many :post_images, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :user_rooms, dependent: :destroy

  # フォローする側
  has_many :relationships, foreign_key: :following_id, dependent: :destroy
  # フォローする人がrelationshipsを経由してフォローしてる人を全員取ってくる
  has_many :followings, through: :relationships, source: :follower

  # フォローされる側
  # relationshipにすると重複してしまうため、reverse_of_relationshipsと命名する。
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: :follower_id, dependent: :destroy
  # フォローされている人が、relationshipsを経由して自分をフォローしている人を全員取ってくる
  has_many :followers, through: :reverse_of_relationships, source: :following

  # あるユーザーが引数に渡されたユーザーにフォローされているのか、いないのか判定するメソッド
  def is_followed_by?(user)
    reverse_of_relationships.find_by(following_id: user.id).present?
  end

end
