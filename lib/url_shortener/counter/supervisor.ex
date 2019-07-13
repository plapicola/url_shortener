defmodule Counter.Supervisor do
  use Supervisor

  alias Counter.AccessCounter

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(AccessCounter, [[name: AccessCounter]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end