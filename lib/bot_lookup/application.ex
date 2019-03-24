defmodule BotLookup.Application do
  use Application

  def start(_type, _args) do
    children = [
      {BotLookup, []}
    ]

    opts = [strategy: :one_for_one, name: BotLookup.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
