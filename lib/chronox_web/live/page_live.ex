defmodule ChronoxWeb.PageLive do
  use ChronoxWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, %{})}
  end

  def handle_event("get_availability", _value, socket) do
    {:noreply, push_redirect(socket, to: "/availabilty/#{Ecto.UUID.generate()}")}
  end
end
