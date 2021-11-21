# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_secure_token :auth_token

  has_many :daily_reports, dependent: :destroy

  validates :email, presence: true, length: { maximum: 254 }
  validates :email, format: { with: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/, if: -> { email.present? } }
  validates :password, presence: true
  validates :password, format: { with: /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)[a-zA-Z\d]+\z/, if: lambda {
                                                                                                 password.present?
                                                                                               } }
  validates :password, length: { within: 8..72, allow_blank: true }

  private

  def email_uniquness
    return unless User.where.not(id: id).exists?(email: email)

    errors.add(:base, 'emailを修正してください')
  end
end
