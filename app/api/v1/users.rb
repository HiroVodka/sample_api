# frozen_string_literal: true

module V1
  class Users < Grape::API
    resources 'users' do
      desc 'signup'
      params do
        requires :name, type: String
        requires :email, type: String
        requires :password, type: String
      end
      post '/signup' do
        @user = User.new(name: params[:name], email: params[:email], password: params[:password])
        @user.save!
      end

      desc 'signin'
      params do
        requires :email, type: String
        requires :password, type: String
      end
      post '/signin' do
        @user = User.find_by(email: params[:email])

        render_401 unless @user&.authenticate(params[:password])

        { auth_token: @user.auth_token }
      end

      desc '詳細'
      get '/account' do
        @user = current_user
      end
    end
  end
end
