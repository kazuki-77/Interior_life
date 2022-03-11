# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:twitter]

  attachment :profile_image, destroy: false

  validates :name, length: { maximum: 20, minimum: 2 }, uniqueness: true

  has_many :sns_credentials
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

  def self.from_omniauth(auth)
    # binding.pry
    # sns認証したことがあればアソシエーションで取得
   # 無ければemailでユーザー検索して取得orビルド(保存はしない)
    sns = SnsCredential.where(provider: auth.provider, uid: auth.uid).first_or_create # first_or_createメソッドを使うことで、DBに保存するかどうかを判断する
    user = User.where("users.email LIKE ?", "#{auth["extra"]["access_token"].params[:user_id]}-%")
               .first_or_initialize(name: auth.info.name, email: auth.info.email)
    # userが登録済みであるか判断
   if user.persisted?
     sns.user = user
     sns.save
   end
   { user: user, sns: sns }
  end
end
