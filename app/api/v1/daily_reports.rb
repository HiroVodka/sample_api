module V1
  class DailyReports < Grape::API
    resources "daily-reports" do
      desc 'index'
      get '/' do
        @daily_reports = DailyReport.all
      end
      desc '詳細'
      params do
        requires :id, type: Integer
      end
      get '/:id' do
        @daily_report = DailyReport.find(params[:id])
      end

      desc '新規作成'
      params do
        requires :title, type: String
        requires :body, type: String
      end
      post '/' do
        @daily_report = DailyReport.create!(title: params[:title], body: params[:body])
      end

      desc '削除'
      params do
        requires :id
      end
      delete ':id' do
        DailyReport.find(params[:id]).destroy!
      end
    end
  end
end
