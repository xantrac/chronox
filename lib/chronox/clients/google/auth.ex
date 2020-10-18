defmodule Chronox.Clients.Google.Auth do
  use HTTPoison.Base

  def app_auth_request(availability_uuid) do
    get!(google_auth_url(), [{"Content-Type", "application/json"}],
      params: %{
        state: availability_uuid,
        client_id: client_id(),
        redirect_uri: redirect_uri(),
        response_type: "code",
        scopes: "email calendar"
      }
    )
  end

  def exchange_auth_code_with_token(auth_code) do
    %{body: body} =
      post!(
        google_token_url(),
        auth_code_exchange_payload(auth_code),
        [{"Content-Type", "application/x-www-form-urlencoded"}, {"Accept", "application/json"}]
      )

    body
    |> Jason.decode!()
  end

  def user_auth_redirect_url(availability_uuid) do
    "#{google_auth_url()}?scope=email https://www.googleapis.com/auth/calendar&include_granted_scopes=true&response_type=code&redirect_uri=http://localhost:4000/auth/google/callback&client_id=#{
      client_id()
    }&state=#{availability_uuid}"
  end

  defp auth_code_exchange_payload(auth_code) do
    "code=#{auth_code}&client_id=#{client_id()}&client_secret=#{client_secret()}&redirect_uri=#{
      redirect_uri()
    }&grant_type=authorization_code"
  end

  defp google_token_url do
    "https://oauth2.googleapis.com/token"
  end

  defp google_auth_url do
    "https://accounts.google.com/o/oauth2/v2/auth"
  end

  defp redirect_uri do
    Application.get_env(:chronox, :google_api_redirect_uri)
  end

  defp client_id do
    Application.get_env(:chronox, :google_api_client_id)
  end

  defp client_secret do
    Application.get_env(:chronox, :google_api_client_secret)
  end
end
