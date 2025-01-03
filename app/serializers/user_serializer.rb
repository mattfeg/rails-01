class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :cpf, :birthdate, :resume, :profile
  def resume
    "#{object.id}:#{object.name}"
  end
end
