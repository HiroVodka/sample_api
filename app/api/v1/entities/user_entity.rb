module V1
  module Entities
    class User < Grape::Entity
      expose :id
      expose :name
      expose :email
    end
  end
end
