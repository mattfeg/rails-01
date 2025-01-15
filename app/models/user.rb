class User < ApplicationRecord
  validates :name, presence: true
  validates :cpf, presence: true
  validates :birthdate, presence: true
  validates :role, inclusion: { in: %w[admin regular_user], message: "The 'role' param only accepts 'admin' and 'regular_user' values."  }
  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile

  enum :role, { admin: 0, regular_user: 1 }
  scope :filter_by_name, ->(name) { where("LOWER(name) LIKE ?", "%#{name.downcase}%") }
end
