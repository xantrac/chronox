defmodule Chronox.BusyTimeSubscription do
  alias Phoenix.PubSub

  def subscribe do
    PubSub.subscribe(Chronox.PubSub, "busy_time")
  end

  def broadcast_update_calendar do
    PubSub.broadcast(Chronox.PubSub, "busy_time", :updated_calendar)
  end
end
