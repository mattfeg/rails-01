class User < ApplicationRecord
  enum :role, { admin: 1, regular_user: 2 }

  validates :name, presence: true
  validates :cpf, presence: true
  validates :birthdate, presence: true
  validates :role, inclusion: { in: roles.keys, message: "The 'role' param only accepts 1 for admin and 2 for regular_user values."  }
  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile

  scope :filter_by_name, ->(name) { where("LOWER(name) LIKE ?", "%#{name.downcase}%") }
end
