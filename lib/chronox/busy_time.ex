defmodule Chronox.BusyTime do
  alias Chronox.Clients.Google

  def get_for_accounts(accounts) do
    accounts
    |> Enum.flat_map(fn {_, %{calendars: calendars, token: token}} ->
      Enum.map(calendars, &{&1, token})
    end)
    |> Enum.map(&fetch_busy_time_task(&1))
    |> Task.await_many()
    |> List.flatten()
  end

  defp fetch_busy_time_task({id, token}) do
    now = DateTime.utc_now() |> DateTime.to_iso8601()

    one_month_from_now =
      DateTime.utc_now() |> DateTime.add(2_592_000, :second) |> DateTime.to_iso8601()

    Task.async(fn -> Google.get_busy_time(id, now, one_month_from_now, token) end)
  end
end
