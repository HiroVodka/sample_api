# frozen_string_literal: true

module V1
  module Entities
    class DailyReportEntity < Grape::Entity
      expose :id, :user_id, :title, :body, :created_at
      expose :comments, using: CommentEntity
    end
  end
end
