defmodule Chronox.BusyTimeServer do
  use GenServer

  alias Chronox.AccountsServer
  alias Chronox.BusyTime

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def get_busy_time() do
    GenServer.call(__MODULE__, :get_busy_time)
  end

  def init(busy_time) do
    {:ok, busy_time, {:continue, :schedule_busy_time_poller}}
  end

  def handle_call(:get_busy_time, _from, busy_time) do
    {:reply, busy_time, busy_time}
  end
  def handle_continue(:schedule_busy_time_poller, busy_time) do
    Process.send_after(self(), :poll_busy_time, 10000)
    {:noreply, busy_time}
  end

  def handle_info(:poll_busy_time, busy_time) do
    polled_busy_time = 
    AccountsServer.get_accounts()
    |> BusyTime.get_for_accounts()

    {:noreply, polled_busy_time, {:continue, :schedule_busy_time_poller}}
  end
end
