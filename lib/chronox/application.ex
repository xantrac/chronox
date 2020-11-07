defmodule Chronox.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Chronox.Repo,
      # Start the Telemetry supervisor
      ChronoxWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Chronox.PubSub},
      # Start the Endpoint (http/https)
      ChronoxWeb.Endpoint,
      # Start a worker by calling: Chronox.Worker.start_link(arg)
      # {Chronox.Worker, arg}
      {Chronox.UserServer, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Chronox.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ChronoxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
