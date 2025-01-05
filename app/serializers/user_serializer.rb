class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :cpf, :birthdate, :resume
  has_one :profile
  def resume
    "#{object.id}:#{object.name}"
  end
end
