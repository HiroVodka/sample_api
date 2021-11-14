require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "POST /users/signup" do
    def requested
      post "/v1/users/signup", params: params.to_json, headers: { "Content-Type": "application/json" }
    end

    context "正常にUserが作成される場合" do
      let(:params) do
        {
          name: "test",
          email: "example@example.com",
          password: "Test1234"
        }
      end

      it "200が返り、userが新規作成されること" do
        expect { requested }.to change { User.count }.from(0).to(1)
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

      it "400エラーが返ること" do
        binding.irb
      end
    end
  end
end
