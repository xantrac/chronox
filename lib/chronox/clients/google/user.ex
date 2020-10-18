defmodule Chronox.Clients.Google.User do
  use HTTPoison.Base

  def get_user_email(token) do
    get!("https://www.googleapis.com/oauth2/v3/userinfo", [
      {"Authorization", "Bearer #{token}"}
    ])
  end

  def process_response_body(body) do
    body
    |> Jason.decode!()
  end
end
