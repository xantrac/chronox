# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :chronox,
  ecto_repos: [Chronox.Repo]

# Configures the endpoint
config :chronox, ChronoxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rr00BhWBsKy0OjCDC5rBOqzp6otqlWALXlLfjdN9CO/44m4jBSLIBBonVg+q5TOh",
  render_errors: [view: ChronoxWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Chronox.PubSub,
  live_view: [signing_salt: "5EXbmwJR"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.

config :ueberauth, Ueberauth,
  providers: [
    google:
      {Ueberauth.Strategy.Google,
       [default_scope: "email https://www.googleapis.com/auth/calendar"]}
  ]

import_config "#{Mix.env()}.exs"
