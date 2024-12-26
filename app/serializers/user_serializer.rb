class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :cpf, :birthdate, :resume
end
