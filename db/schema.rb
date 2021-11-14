# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_211_111_141_127) do
  create_table 'daily_reports', id: :bigint, unsigned: true,
                                options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci', comment: '日報', force: :cascade do |t|
    t.string 'title', null: false
    t.text 'body', null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.datetime 'created_at', precision: 6, null: false
  end

  create_table 'users', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci',
                        force: :cascade do |t|
    t.string 'email', null: false
    t.string 'name', null: false
    t.string 'password_digest', null: false
    t.string 'auth_token', charset: 'utf8', collation: 'utf8_bin'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end
end