defmodule Feelis.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      FeelisWeb.Telemetry,
      # Start the Ecto repository
      Feelis.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Feelis.PubSub},
      # Start Finch
      {Finch, name: Feelis.Finch},
      # Start the Endpoint (http/https)
      Feelis.Presence,
      FeelisWeb.Endpoint
      # Start a worker by calling: Feelis.Worker.start_link(arg)
      # {Feelis.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Feelis.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FeelisWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
