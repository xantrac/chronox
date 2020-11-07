defmodule ChronoxWeb.PageLive do
  use ChronoxWeb, :live_view

  alias Chronox.AccountsServer
  alias Chronox.BusyTime
  alias Chronox.BusyTimeServer

  def mount(_params, _session, socket) do
    users =
      AccountsServer.get_accounts()
      |> Enum.map(fn {email, user_data} -> Map.put(user_data, :email, email) end)

    {:ok,
     assign(socket, %{
       users: users,
       busy_time_from_api: %{duration: nil, slots: []},
       busy_time_from_server: %{duration: nil, slots: []}
     })}
  end

  def handle_event("add_calendar", _value, socket) do
    {:noreply, redirect(socket, to: "/auth/google")}
  end

  def handle_event("busy_time_from_server", _value, socket) do
    {microseconds, busy_time} =
      :timer.tc(fn ->
        BusyTimeServer.get_busy_time()
      end)

    {:noreply,
     assign(socket, %{busy_time_from_server: %{duration: microseconds / 1000, slots: busy_time}})}
  end

  def handle_event("busy_time_from_api", _value, socket) do
    {microseconds, busy_time} =
      :timer.tc(fn ->
        AccountsServer.get_accounts()
        |> BusyTime.get_for_accounts()
      end)

    {:noreply,
     assign(socket, %{busy_time_from_api: %{duration: microseconds / 1000, slots: busy_time}})}
  end
end
