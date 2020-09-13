defmodule Chronox.Repo do
  use Ecto.Repo,
    otp_app: :chronox,
    adapter: Ecto.Adapters.Postgres
end
