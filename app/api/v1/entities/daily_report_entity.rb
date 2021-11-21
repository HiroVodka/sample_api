module V1
  module Entities
    class DailyReportEntity < Grape::Entity
      expose :id, :user_id, :title, :body, :created_at
    end
  end
end
