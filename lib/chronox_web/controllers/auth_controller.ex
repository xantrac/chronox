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

  def callback(conn, stuff) do
    IO.inspect(stuff, label: "STUFF")
    # now = DateTime.utc_now() |> DateTime.to_iso8601()

    # one_month_from_now =
    #   DateTime.utc_now() |> DateTime.add(2_592_000, :seconds) |> DateTime.to_iso8601()

    # %{
    #   body: %{
    #     "calendars" => %{
    #       ^email => %{
    #         "busy" => busy_time
    #       }
    #     }
    #   }
    # } = Calendar.get_busy_time(email, now, one_month_from_now, token)

    # UserServer.set_busy_time(availability_uuid, email, busy_time)

    redirect(conn, to: "/")
  end
end
