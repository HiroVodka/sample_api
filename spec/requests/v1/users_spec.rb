require "rails_helper"

RSpec.describe "User", type: :request do
  describe "POST /users/signup" do
    def requested
      post "/v1/users/signup", params: params.to_json, headers: { "Content-Type": "application/json" }
    end

    context "201" do
      let(:params) do
        {
          name: "test",
          email: "example@example.com",
          password: "Test1234"
        }
      end

      it "201が返り、userが新規作成されること" do
        expect { requested }.to change { User.count }.from(0).to(1)
        expect(response).to have_http_status 201
        
        user = User.first
        expect(user.name).to eq "test"
        expect(user.email).to eq "example@example.com"
      end
    end

    context "400" do
      let(:params) do
        {
          name: "test",
          email: "example@example.com",
          password: "1234"
        }
      end
      let(:message) do
        {
          message: "バリデーションに失敗しました: パスワードは不正な値です, パスワードは8文字以上で入力してください",
          status: 400
        }.to_json
      end

      it "400エラーが返ること" do
        requested

        expect(response).to have_http_status 400
        expect(response.body).to eq message
      end
    end

    context "500" do
      let(:params) do
        {
          name: "test",
          email: "example@example.com",
          password: "Test1234"
        }
      end
      let(:message) do
        {
          message: "StandardError",
          status: 500
        }.to_json
      end

      before { allow(User).to receive(:new).and_raise(StandardError) }

      it "500エラーが返ること" do
        requested
        
        expect(response.body).to eq message
      end
    end
  end

  describe "POST /users/signup" do
    def requested
      post "/v1/users/signin", params: params.to_json, headers: { "Content-Type": "application/json" }
    end

    let!(:user) { create(:user) }

    context "201" do
      let(:params) do
        {
          email: "example@example.com",
          password: "Test1234"
        }
      end
      let(:json) do
        {
          auth_token: "#{user.auth_token}"
        }.to_json
      end

      it "201が返り、auth_tokenが返ること" do
        requested

        expect(response).to have_http_status 201
        expect(response.body).to eq json
      end
    end

    context "401" do
      let(:params) do
        {
          email: "example@example.com",
          password: "Test1111"
        }
      end
      let(:message) do
        {
          message: "Unauthorized error",
          status: 401
        }.to_json
      end

      it "401エラーが返ること" do
        requested

        expect(response).to have_http_status 401
        expect(response.body).to eq message
      end
    end

    context "500" do
      
    end
  end
end
