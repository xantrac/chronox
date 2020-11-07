defmodule Chronox.UserServer do
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def get_users() do
    GenServer.call(__MODULE__, :get_users)
  end

  def set_user(email, calendars, bearer_token) do
    GenServer.call(__MODULE__, {:set_user, email, calendars, bearer_token})
  end

  def set_busy_time(uuid, email, busy_time) do
    GenServer.call(__MODULE__, {:set_busy_time, email, busy_time})
  end

  def init(users) do
    {:ok, users}
  end

  def handle_call(:get_users, _from, users) do
    {:reply, users, users}
  end

  def handle_call({:set_user, email, calendars, bearer_token}, _from, users) do
    updates_users =
      users
      |> Map.put(email, %{token: bearer_token, calendars: calendars })

    {:reply, updates_users, updates_users}
  end

  def handle_call({:set_busy_time, email, busy_time}, _from, users) do
    updates_users = put_in(users, [email, "busy_time"], busy_time)

    {:reply, updates_users, updates_users}
  end
end
