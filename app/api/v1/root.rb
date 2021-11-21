# frozen_string_literal: true

module V1
  class Root < Grape::API
    class UnauthorizedError < StandardError; end

    version :v1
    format :json

    rescue_from UnauthorizedError do
      rack_response({ message: 'Unauthorized error', status: 401 }.to_json, 401)
    end

    rescue_from ActiveRecord::RecordNotFound do |_e|
      rack_response({ message: 'リソースが存在しません', status: 404 }.to_json, 404)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      rack_response({ message: e.message, status: 400 }.to_json, 400)
    end

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      rack_response e.to_json, 400
    end

    # 開発環境でエラー詳細を見たい場合はコメントアウト
    # rescue_from :all do |e|
    #   rack_response({ message: e.message, status: 500 }.to_json, 500)
    # end

    helpers do
      def authenticate_user!
        raise render_401 unless current_user
      end

      def current_user
        auth_token = headers['Authorization']&.gsub(/^Bearer\s/, '')
        user = User.find_by(auth_token: auth_token)
        return render_401 unless user

        user
      end

      def render_401
        raise UnauthorizedError
      end
    end

    mount V1::DailyReports
    mount V1::Users

    add_swagger_documentation
  end
end
