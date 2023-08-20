defmodule Feelis.Repo do
  use Ecto.Repo,
    otp_app: :feelis,
    adapter: Ecto.Adapters.Postgres
end
