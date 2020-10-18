defmodule Chronox.UserServer do
  use GenServer

  def start_link(%{uuid: uuid}) do
    GenServer.start_link(__MODULE__, %{}, name: String.to_atom(uuid))
  end

  def get_users(uuid) do
    GenServer.call(String.to_atom(uuid), :get_users)
  end

  @spec set_user(binary, any, any) :: any
  def set_user(uuid, email, bearer_token) do
    GenServer.call(String.to_atom(uuid), {:set_user, email, bearer_token})
  end

  def set_busy_time(uuid, email, busy_time) do
    GenServer.call(String.to_atom(uuid), {:set_busy_time, email, busy_time})
  end

  # def set_user(uuid, user)

  @impl true
  def init(users) do
    {:ok, users}
  end

  @impl true
  def handle_call(:get_users, _from, users) do
    {:reply, users, users}
  end

  def handle_call({:set_user, email, bearer_token}, _from, users) do
    updates_users =
      users
      |> Map.put(email, %{"token" => bearer_token})

    {:reply, updates_users, updates_users}
  end

  def handle_call({:set_busy_time, email, busy_time}, _from, users) do
    updates_users = put_in(users, [email, "busy_time"], busy_time)

    {:reply, updates_users, updates_users}
  end
end
