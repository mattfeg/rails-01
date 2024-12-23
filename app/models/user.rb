class User < ApplicationRecord
  validates :name, presence: true
  validates :cpf, presence: true
  validates :birthdate, presence: true

  scope :filter_by_name, ->(name) { where("LOWER(name) LIKE ?", "%#{name.downcase}%") }
end
