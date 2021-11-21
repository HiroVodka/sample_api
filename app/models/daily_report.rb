# frozen_string_literal: true

class DailyReport < ApplicationRecord
  belongs_to :user
  has_many :comments
end
