defmodule TodoAppRe.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TodoAppReWeb.Telemetry,
      TodoAppRe.Repo,
      {DNSCluster, query: Application.get_env(:todo_app_re, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TodoAppRe.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TodoAppRe.Finch},
      # Start a worker by calling: TodoAppRe.Worker.start_link(arg)
      # {TodoAppRe.Worker, arg},
      # Start to serve requests, typically the last entry
      TodoAppReWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TodoAppRe.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TodoAppReWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
