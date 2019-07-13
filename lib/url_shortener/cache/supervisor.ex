defmodule Cache.Supervisor do
  use Supervisor

  alias Cache.LinkCache

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(LinkCache, [[name: LinkCache]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end