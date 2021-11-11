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

        if @user.save
        end
        @user
      end

      post '/signin' do
        @user = User.find_by(email: params[:email])
        if @user.authenticate(params[:password])
          @user.regenerate_auth_token
          @user
        else
          error!('Unauthorized. Invalid email or password.', 401)
        end
      end
    end
  end
end
