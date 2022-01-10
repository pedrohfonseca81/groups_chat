defmodule GroupsChat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      GroupsChat.Repo,
      # Start the Telemetry supervisor
      GroupsChatWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: GroupsChat.PubSub},
      # Start the Endpoint (http/https)
      GroupsChatWeb.Endpoint,
      # Start a worker by calling: GroupsChat.Worker.start_link(arg)
      # {GroupsChat.Worker, arg}
      GroupsChatWeb.Presence
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GroupsChat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    GroupsChatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
