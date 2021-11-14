module V1
  module Entities
    class UserEntity < Grape::Entity
      expose :id, :name, :email
    end
  end
end
