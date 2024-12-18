class GithubController < ApplicationController
  def authorize
    response = HTTP
      .headers("Accept" => "application/json")
      .post("https://github.com/login/oauth/access_token",
            form: {
              client_id: ENV["GITHUB_CLIENT_ID"],
              client_secret: ENV["GITHUB_CLIENT_SECRET"],
              code: params[:code],
            })
    github_access_token = response.parse["access_token"]
    cookies.signed[:github_access_token] = { value: github_access_token, httponly: true }
    redirect_to "http://localhost:5173"
  end

  def profile
    github_access_token = cookies.signed[:github_access_token]
    if github_access_token
      response = HTTP
        .headers("Authorization" => "Bearer #{github_access_token}")
        .get("https://api.github.com/user")
      render json: response.parse
    else
      render json: {}, status: :unauthorized
    end
  end
end
