# frozen_string_literal: true

module V1
  class Root < Grape::API
    version :v1
    format :json

    mount V1::DailyReports

    add_swagger_documentation
  end
end
