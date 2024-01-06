defmodule Digga.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DiggaWeb.Telemetry,
      Digga.Repo,
      {DNSCluster, query: Application.get_env(:digga, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Digga.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Digga.Finch},
      # Start a worker by calling: Digga.Worker.start_link(arg)
      # {Digga.Worker, arg},
      # Start to serve requests, typically the last entry
      DiggaWeb.Endpoint,
      {Cachex, name: :general_cache}, # You can add additional caches with different names

      {Oban, oban_config()},
      chatbot_service(),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Digga.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DiggaWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp oban_config do
    Application.fetch_env!(:digga, Oban)
  end

  # Dont start the genserver in test mode
  defp chatbot_service do
    if Application.get_env(:digga, :env) == :test,
      do: Digga.Chatbot.Server.Mock,
      else: Digga.Chatbot.Server
  end
end
