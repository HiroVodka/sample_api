# frozen_string_literal: true

module V1
  class DailyReports < Grape::API
    resources 'daily-reports' do
      before { authenticate_user! }

      desc '一覧'
      params do
        optional :user_id, type: Integer
        optional :user_name_like, type: String
        optional :from, type: String
        optional :to, type: String
        optional :sort, type: String
        optional :order_by, type: String
      end

      get '/' do
        parsed_params = JSON.parse(params.keys.first)

        if parsed_params.blank?
          @daily_reports = DailyReport.all.order(id: 'DESC')
        else
          form = Search::DailyReport.new(parsed_params)

          error!({ messages: form.errors.full_messages, status: 400 }, 400) unless form.valid?
          @daily_reports = form.search
        end

        present @daily_reports, with: Entities::DailyReportEntity
      end

      desc '詳細'
      params do
        requires :id, type: Integer
      end
      get '/:id' do
        @daily_report = DailyReport.find(params[:id])
        present @daily_report, with: Entities::DailyReportEntity
      end

      desc '新規作成'
      params do
        requires :title, type: String
        requires :body, type: String
      end
      post '/' do
        @daily_report = DailyReport.new(title: params[:title], body: params[:body])
        @daily_report.user = current_user
        @daily_report.save!
        present @daily_report, with: Entities::DailyReportEntity
      end

      desc '更新'
      params do
        requires :id, type: Integer
        optional :title, type: String
        optional :body, type: String
      end
      put ':id' do
        @daily_report = DailyReport.find_by!(id: params[:id], user_id: current_user.id)
        @daily_report.update!(title: params[:title], body: params[:body])
        present @daily_report, with: Entities::DailyReportEntity
      end

      desc '削除'
      params do
        requires :id
      end
      delete ':id' do
        daily_report = DailyReport.find_by!(id: params[:id], user_id: current_user.id)
        daily_report.destroy!
        status 204
        { message: '削除に成功しました', status: 204 }.to_json
      end
    end
  end
end
