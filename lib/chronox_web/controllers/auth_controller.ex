defmodule ChronoxWeb.AuthController do
  use ChronoxWeb, :controller

  def request(conn, _) do
    %{status_code: 302} = app_auth_request()

    redirect(conn, external: user_auth_redirect_url())
  end

  def callback(conn, %{"code" => auth_code}) do
    resp = exchange_auth_code_request(auth_code)
    IO.inspect(resp)

    redirect(conn, to: "/")
  end

  def app_auth_request do
    HTTPoison.get!(google_auth_url(), [{"Content-Type", "application/json"}],
      params: %{
        client_id: client_id(),
        redirect_uri: "http://localhost:4000/auth/google/callback",
        response_type: "code",
        scopes: "calendar"
      }
    )
  end

  def exchange_auth_code_request(auth_code) do
    HTTPoison.post!(
      "https://oauth2.googleapis.com/token",
      auth_code_exchange_payload(auth_code),
      [{"Content-Type", "application/x-www-form-urlencoded"}, {"Accept", "application/json"}]
    )
  end

  def auth_code_exchange_payload(auth_code) do
    "code=#{auth_code}&client_id=#{client_id()}&client_secret=#{client_secret()}&redirect_uri=http://localhost:4000/auth/google/callback&grant_type=authorization_code"
  end

  def user_auth_redirect_url do
    "#{google_auth_url()}?scope=https://www.googleapis.com/auth/calendar&include_granted_scopes=true&response_type=code&redirect_uri=http://localhost:4000/auth/google/callback&client_id=#{
      client_id()
    }"
  end

  def google_auth_url do
    "https://accounts.google.com/o/oauth2/v2/auth"
  end

  defp client_id do
    Application.get_env(:chronox, :google_api_client_id)
  end

  defp client_secret do
    Application.get_env(:chronox, :google_api_client_secret)
  end
end
