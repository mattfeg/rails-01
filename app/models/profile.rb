class Profile < ApplicationRecord
  belongs_to :user
  validates :user, presence: true
  validates :image, presence: false
  validates :is_active, inclusion: { in: [ true, false ] }
end
