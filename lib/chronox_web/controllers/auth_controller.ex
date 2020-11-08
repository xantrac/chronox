defmodule ChronoxWeb.AuthController do
  use ChronoxWeb, :controller

  plug Ueberauth

  alias Chronox.Clients.Google
  alias Chronox.AccountsServer

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    %{credentials: %{token: token}, info: %{email: email}} = auth

    calendars = Google.get_calendars_list(token)
    AccountsServer.set_account(email, calendars, token)

    redirect(conn, to: "/")
  end
end
