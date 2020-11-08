defmodule ChronoxWeb.PageLive do
  use ChronoxWeb, :live_view

  alias Chronox.AccountsServer
  alias Chronox.BusyTime
  alias Chronox.BusyTimeServer
  alias Chronox.BusyTimeSubscription

  def mount(_params, _session, socket) do
    BusyTimeSubscription.subscribe()

    users =
      AccountsServer.get_accounts()
      |> Enum.map(fn {email, user_data} -> Map.put(user_data, :email, email) end)

    {:ok,
     assign(socket, %{
       users: users,
       busy_time: [],
       request_duration: nil,
       real_time: nil
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
     assign(socket, %{
       request_duration: microseconds / 1000,
       busy_time: format_busy_time(busy_time)
     })}
  end

  def handle_event("busy_time_from_api", _value, socket) do
    {microseconds, busy_time} =
      :timer.tc(fn ->
        AccountsServer.get_accounts()
        |> BusyTime.get_for_accounts()
      end)

    {:noreply,
     assign(socket, %{
       request_duration: microseconds / 1000,
       busy_time: format_busy_time(busy_time)
     })}
  end

  def handle_info(:updated_calendar, %{assigns: %{real_time: "on"}} = socket) do
    {microseconds, busy_time} =
      :timer.tc(fn ->
        BusyTimeServer.get_busy_time()
      end)

    {:noreply,
     assign(socket, %{
       request_duration: microseconds / 1000,
       busy_time: format_busy_time(busy_time)
     })}
  end

  def handle_info(:updated_calendar, socket) do
    {:noreply, socket}
  end

  def handle_event("toggle_real_time", params, socket) do
    {:noreply, assign(socket, %{real_time: params["value"]})}
  end

  defp format_busy_time(busy_time) do
    Enum.reduce(busy_time, %{}, fn %{"start" => start_time, "end" => end_time}, acc ->
      [start_datetime, end_datetime] =
        [start_time, end_time]
        |> Enum.map(fn string ->
          {:ok, date_time, _} = DateTime.from_iso8601(string)
          date_time
        end)

      date_key = start_datetime |> DateTime.to_date() |> Date.to_string()

      [start_key, end_key] =
        [start_datetime, end_datetime]
        |> Enum.map(&(&1 |> DateTime.to_time() |> Time.to_string()))

      acc = Map.put_new(acc, date_key, [])

      %{
        acc
        | date_key =>
            ["#{start_key}-#{end_key}" | acc[date_key]] |> Enum.uniq() |> Enum.sort(&(&1 <= &2))
      }
    end)
  end
end
