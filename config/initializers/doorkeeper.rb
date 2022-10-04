# frozen_string_literal: true

Doorkeeper.configure do
  orm :active_record

  resource_owner_from_credentials do |_routes|
    user = User.authenticate(params[:username], params[:password])
    if user
      user.set_last_login_at(Time.now.in_time_zone)
      user.set_last_ip_address(request.remote_ip)
      user.increment :sign_in_count, 1
    end
    user
  end

  api_only

  grant_flows %w[password]
end