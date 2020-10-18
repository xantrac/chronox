defmodule ChronoxWeb.AuthController do
  use ChronoxWeb, :controller

  alias Chronox.Clients.Google.{Auth, User, Calendar}
  alias Chronox.UserServer

  def request(conn, %{"availability_uuid" => availability_uuid}) do
    %{status_code: 302} = Auth.app_auth_request(availability_uuid)

    redirect(conn, external: Auth.user_auth_redirect_url(availability_uuid))
  end

  def callback(conn, %{"code" => auth_code, "state" => availability_uuid}) do
    %{"access_token" => token} = Auth.exchange_auth_code_with_token(auth_code)
    %{body: %{"email" => email}} = User.get_user_email(token)

    UserServer.set_user(availability_uuid, email, token)
    now = DateTime.utc_now() |> DateTime.to_iso8601()

    one_month_from_now =
      DateTime.utc_now() |> DateTime.add(2_592_000, :seconds) |> DateTime.to_iso8601()

    %{
      body: %{
        "calendars" => %{
          ^email => %{
            "busy" => busy_time
          }
        }
      }
    } = Calendar.get_busy_time(email, now, one_month_from_now, token)

    UserServer.set_busy_time(availability_uuid, email, busy_time)

    redirect(conn, to: "/availabilty/#{availability_uuid}")
  end
end
