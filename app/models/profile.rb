class Profile < ApplicationRecord
  belongs_to :user
  validates :user, presence: true
  validates :image, presence: true
  validates :is_active, presence: true
end
