class Relationship < ApplicationRecord
  # フォローするユーザーに結びついている
  belongs_to :following, class_name: 'User'
  # フォローされるユーザーに結びついている
  belongs_to :follower, class_name: 'User'
end
