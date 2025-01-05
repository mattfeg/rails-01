class User < ApplicationRecord
  validates :name, presence: true
  validates :cpf, presence: true
  validates :birthdate, presence: true
  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile

  scope :filter_by_name, ->(name) { where("LOWER(name) LIKE ?", "%#{name.downcase}%") }

  after_create :create_default_profile

  def create_default_profile
    self.build_profile(is_active: true).save
  end
end
