# frozen_string_literal: true

module V1
  module Entities
    class CommentEntity < Grape::Entity
      expose :id
      expose :user, using: UserEntity
      expose :body, :created_at
    end
  end
end
