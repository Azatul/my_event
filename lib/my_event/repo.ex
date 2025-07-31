defmodule MyEvent.Repo do
  use Ecto.Repo,
    otp_app: :my_event,
    adapter: Ecto.Adapters.Postgres
end
