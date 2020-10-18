defmodule ChronoxWeb.AvailabilityLive do
  use ChronoxWeb, :live_view

  alias Chronox.UserServer

  def mount(%{"uuid" => uuid}, _session, socket) do
    UserServer.start_link(%{uuid: uuid})

    {:ok, assign(socket, %{uuid: uuid})}
  end

  def handle_event("add_calendar", _value, socket) do
    %{assigns: %{uuid: uuid}} = socket
    {:noreply, redirect(socket, to: "/auth/google/#{uuid}")}
  end
end
