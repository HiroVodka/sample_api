# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DailyReports', type: :request do
  let!(:user) { create(:user, name: 'test', email: 'example@example.com', id: 1) }
  let(:header) { { "Content-Type": 'application/json' }.merge @env }

  before { authenticate(user) }

  describe 'GET /daily-reports' do
    def requested
      get '/v1/daily-reports', params: params.to_json, headers: header
    end

    let!(:daily_report_1) { create(:daily_report, user: user, id: 1) }
    let!(:daily_report_2) { create(:daily_report, user: user, id: 2) }
    let!(:other_user_daily_report) { create(:daily_report, user: other_user, id: 3) }
    let!(:other_user) { create(:user, name: 'hoge', email: 'example2@example.com', id: 2) }
    let(:params) { {} }

    context '200' do
      let(:json) do
        [
          {
            id: 3,
            user_id: 2,
            title: 'test',
            body: 'hogehoge',
            created_at: other_user_daily_report.created_at,
            comments: []
          },
          {
            id: 2,
            user_id: 1,
            title: 'test',
            body: 'hogehoge',
            created_at: daily_report_2.created_at,
            comments: []
          },
          {
            id: 1,
            user_id: 1,
            title: 'test',
            body: 'hogehoge',
            created_at: daily_report_1.created_at,
            comments: []
          }
        ].to_json
      end
      it '200が返り、3件のdaily_reportがidの降順で返ること' do
        requested

        expect(response).to have_http_status 200
        expect(response.body).to eq json
      end

      context '名前でlike検索' do
        let(:params) { { user_name_like: 'test' } }
        let(:json) do
          [
            {
              id: 2,
              user_id: 1,
              title: 'test',
              body: 'hogehoge',
              created_at: daily_report_2.created_at,
              comments: []
            },
            {
              id: 1,
              user_id: 1,
              title: 'test',
              body: 'hogehoge',
              created_at: daily_report_1.created_at,
              comments: []
            }
          ].to_json
        end

        it '200が返り、user_name: testのdaily_reportのみ返ること' do
          requested

          expect(response).to have_http_status 200
          expect(response.body).to eq json
        end
      end
    end

    context '400' do
      let(:params) { { sort: 'hogehoge' } }
      let(:message) do
        {
          messages: ['Sortは一覧にありません'],
          status: 400
        }.to_json
      end

      it '400エラーが返ること' do
        requested

        expect(response).to have_http_status 400
        expect(response.body).to eq message
      end
    end
  end

  describe 'GET /daily-reports/:id' do
    def requested
      get "/v1/daily-reports/#{path}", headers: header
    end

    let!(:daily_report) { create(:daily_report, user: user, id: 1) }
    let(:path) { 1 }

    context '200' do
      let(:json) do
        {
          id: 1,
          user_id: 1,
          title: 'test',
          body: 'hogehoge',
          created_at: daily_report.created_at,
          comments: []
        }.to_json
      end
      it '200が返り、id:1のdaily_reportが返ること' do
        requested

        expect(response).to have_http_status 200
        expect(response.body).to eq json
      end
    end

    context '404' do
      let(:path) { 999 }
      let(:message) do
        {
          message: 'リソースが存在しません',
          status: 404
        }.to_json
      end

      it '404が返ること' do
        requested

        expect(response).to have_http_status 404
        expect(response.body).to eq message
      end
    end
  end

  describe 'POST /daily-reports' do
    def requested
      post '/v1/daily-reports', params: params.to_json, headers: header
    end

    let(:params) do
      {
        title: 'test',
        body: '今日やったこと'
      }
    end
    let(:daily_report) { ::DailyReport.first }

    context '201' do
      let(:json) do
        {
          id: daily_report.id,
          user_id: 1,
          title: 'test',
          body: '今日やったこと',
          created_at: daily_report.created_at,
          comments: []
        }.to_json
      end
      it '201が返り、user:1のdaily_reportが作成されること' do
        expect(response).to have_http_status 201
        expect(response.body).to eq json
      end
    end
  end

  describe 'PUT /daily-reports/:id' do
    def requested
      put "/v1/daily-reports/#{path}", params: params.to_json, headers: header
    end

    let!(:daily_report) { create(:daily_report, title: 'test', body: 'body', user: user, id: 1) }
    let(:params) do
      {
        title: 'test_after',
        body: 'body_after'
      }
    end
    let(:path) { 1 }

    context '200' do
      let(:json) do
        {
          id: daily_report.id,
          user_id: 1,
          title: 'test_after',
          body: 'body_after',
          created_at: daily_report.created_at,
          comments: []
        }.to_json
      end
      it '200が返り、user:1のdaily_reportが作成されること' do
        requested

        expect(response).to have_http_status 200
        expect(response.body).to eq json
      end
    end

    context '404' do
      let(:path) { 999 }
      let(:message) do
        {
          message: 'リソースが存在しません',
          status: 404
        }.to_json
      end

      it '404が返ること' do
        requested

        expect(response).to have_http_status 404
        expect(response.body).to eq message
      end
    end
  end

  describe 'DELETE /daily-reports/:id' do
    def requested
      delete "/v1/daily-reports/#{path}", headers: header
    end
    let(:path) { 1 }

    before { create(:daily_report, user: user, id: 1) }

    context '204' do
      let(:json) { { message: '削除に成功しました', status: 204 }.to_json }
      it '204が返ること' do
        requested

        expect(response).to have_http_status 204
        expect(response.body).to eq json
      end
    end

    context '404' do
      let!(:other_user) { create(:user, email: 'other@example.com') }
      let(:path) { other_user.id }
      let(:message) do
        {
          message: 'リソースが存在しません',
          status: 404
        }.to_json
      end

      before { create(:daily_report, user: other_user) }

      it '404が返ること' do
        requested

        expect(response).to have_http_status 404
        expect(response.body).to eq message
      end
    end
  end
end
