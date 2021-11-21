# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DailyReports', type: :request do
  let!(:user) { create(:user, name: 'test', email: 'example@example.com', id: 1) }
  let(:header) { { "Content-Type": 'application/json' }.merge @env }

  before { authenticate(user) }

  describe 'POST /daily-reports/:daily_report_id/comments' do
    def requested
      post "/v1/daily-reports/#{path}/comments", params: params.to_json, headers: header
    end

    let!(:daily_report) { create(:daily_report, user: user, id: 1) }
    let(:comment) { Comment.first }
    let(:params) { { body: 'body' } }
    let(:path) { 1 }

    context '201' do
      let(:json) do
        {
          id: daily_report.id,
          user_id: 1,
          title: 'test',
          body: 'hogehoge',
          created_at: daily_report.created_at,
          comments: [
            {
              id: comment.id,
              user: {
                id: 1,
                name: 'test',
                email: 'example@example.com'
              },
              body: 'body',
              created_at: comment.created_at
            }
          ]
        }.to_json
      end
      it '201が返り、daily_reportの詳細が返ること' do
        expect { requested }.to change { Comment.count }.from(0).to(1)

        expect(response).to have_http_status 201
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

  describe 'PUT /daily-reports/:daily_report_id/comments/:id' do
    def requested
      put "/v1/daily-reports/#{report_path}/comments/#{comment_path}", params: params.to_json, headers: header
    end
    let(:comment_path) { user.id }
    let(:report_path) { daily_report.id }
    let!(:daily_report) { create(:daily_report, user: user, id: 1) }
    let!(:comment) { create(:comment, user: user, daily_report: daily_report, id: 1, body: 'body') }
    let(:params) { { body: 'body_after' } }

    context '200' do
      let(:json) do
        {
          id: 1,
          user_id: 1,
          title: 'test',
          body: 'hogehoge',
          created_at: daily_report.created_at,
          comments: [
            {
              id: 1,
              user: {
                id: 1,
                name: 'test',
                email: 'example@example.com'
              },
              body: 'body_after',
              created_at: comment.created_at
            }
          ]
        }.to_json
      end

      it '200が返り、daily_reportの詳細が返ること' do
        requested

        expect(response).to have_http_status 200
        expect(response.body).to eq json
      end
    end

    context '404' do
      let(:other_user) { create(:user, email: 'other@example.com') }
      let(:comment) { create(:comment, user: other_user, daily_report: daily_report) }
      let(:comment_path) { other_user.id }
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

  describe 'DELETE /daily-reports/:daily_report_id/comments/:id' do
    def requested
      delete "/v1/daily-reports/#{report_path}/comments/#{comment_path}", headers: header
    end
    let(:comment_path) { user.id }
    let(:report_path) { daily_report.id }
    let!(:daily_report) { create(:daily_report, user: user, id: 1) }
    let!(:comment) { create(:comment, user: user, daily_report: daily_report, id: 1, body: 'body') }

    context '204' do
      let(:json) { { message: '削除に成功しました', status: 204 }.to_json }
      it '204が返ること' do
        requested

        expect(response).to have_http_status 204
        expect(response.body).to eq json
      end
    end

    context '404' do
      let(:other_user) { create(:user, email: 'other@example.com') }
      let(:comment) { create(:comment, user: other_user, daily_report: daily_report) }
      let(:comment_path) { other_user.id }
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
end
