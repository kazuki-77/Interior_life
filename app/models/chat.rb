# frozen_string_literal: true

class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :message, presence: true
end
