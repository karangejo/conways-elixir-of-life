defmodule ConwayPhx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ConwayPhx.Telemetry,
      # Start the Endpoint (http/https)
      ConwayPhx.Endpoint,
      # Start a worker by calling: ConwayPhx.Worker.start_link(arg)
      # {ConwayPhx.Worker, arg}
      {Phoenix.PubSub, name: ConwayPhx.PubSub}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ConwayPhx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ConwayPhx.Endpoint.config_change(changed, removed)
    :ok
  end
end
