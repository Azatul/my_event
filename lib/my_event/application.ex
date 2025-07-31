defmodule MyEvent.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MyEventWeb.Telemetry,
      MyEvent.Repo,
      {DNSCluster, query: Application.get_env(:my_event, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MyEvent.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MyEvent.Finch},
      # Start a worker by calling: MyEvent.Worker.start_link(arg)
      # {MyEvent.Worker, arg},
      # Start to serve requests, typically the last entry
      MyEventWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MyEvent.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MyEventWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
