# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :daily_report, dependent: :destroy
  belongs_to :user
end
