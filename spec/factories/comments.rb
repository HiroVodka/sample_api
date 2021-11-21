# frozen_string_literal: true

FactoryBot.define do
  factory :comment, class: 'Comment' do
    user { nil }
    daily_report { nil }
    body { 'hogehoge' }
  end
end
