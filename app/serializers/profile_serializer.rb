class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :user, :image, :is_active
end
