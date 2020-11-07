defmodule ChronoxWeb.PageLive do
  use ChronoxWeb, :live_view

  alias Chronox.UserServer

  def mount(_params, _session, socket) do
    users =
      UserServer.get_users()
      |> Enum.map(fn {email, user_data} -> Map.put(user_data, :email, email) end)

    {:ok, assign(socket, %{users: users})}
  end

  def handle_event("add_calendar", _value, socket) do
    {:noreply, redirect(socket, to: "/auth/google")}
  end
end
