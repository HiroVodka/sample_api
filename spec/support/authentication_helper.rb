module AuthenticationHelper
  def authenticate(user)
    @env ||= {}
    @env['HTTP_AUTHORIZATION'] = "Bearer #{user.auth_token}"
  end
end

