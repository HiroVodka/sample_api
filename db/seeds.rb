# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
include FactoryBot::Syntax::Methods

ApplicationRecord.transaction do
  pp "---データ 作成---"
  user = create(:user)
  daily_report = create(:daily_report, user: user)
  comment = create(:comment, user: user, daily_report: daily_report)
  pp "---完了---"
end
