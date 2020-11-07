defmodule Chronox.BusyTime do
  alias Chronox.AccountsServer
  alias Chronox.Clients.Google

  def get_for_accounts do
    AccountsServer.get_accounts()
    |> Enum.flat_map(fn {_, %{calendars: calendars, token: token}} ->
      Enum.map(calendars, &{&1, token})
    end)
    |> Enum.map(&fetch_busy_time_task(&1))
    |> Task.await_many()
    |> 
  end

  defp fetch_busy_time_task({id, token}) do
    now = DateTime.utc_now() |> DateTime.to_iso8601()

    one_month_from_now =
      DateTime.utc_now() |> DateTime.add(2_592_000, :seconds) |> DateTime.to_iso8601()

    Task.async(fn -> Google.get_busy_time(id, now, one_month_from_now, token) end)
  end
end
