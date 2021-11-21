# frozen_string_literal: true

FactoryBot.define do
  factory :daily_report, class: 'DailyReport' do
    title { 'test' }
    body { 'hogehoge' }
    user { nil }
  end
end
