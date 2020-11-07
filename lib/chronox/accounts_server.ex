defmodule Chronox.AccountsServer do
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def get_accounts() do
    GenServer.call(__MODULE__, :get_accounts)
  end

  def set_account(email, calendars, bearer_token) do
    GenServer.call(__MODULE__, {:set_account, email, calendars, bearer_token})
  end

  def set_busy_time(uuid, email, busy_time) do
    GenServer.call(__MODULE__, {:set_busy_time, email, busy_time})
  end

  def init(accounts) do
    {:ok, accounts}
  end

  def handle_call(:get_accounts, _from, accounts) do
    {:reply, accounts, accounts}
  end

  def handle_call({:set_account, email, calendars, bearer_token}, _from, accounts) do
    updated_accounts =
      accounts
      |> Map.put(email, %{token: bearer_token, calendars: calendars})

    {:reply, updated_accounts, updated_accounts}
  end

  def handle_call({:set_busy_time, email, busy_time}, _from, accounts) do
    updated_accounts = put_in(accounts, [email, "busy_time"], busy_time)

    {:reply, updated_accounts, updated_accounts}
  end
end
