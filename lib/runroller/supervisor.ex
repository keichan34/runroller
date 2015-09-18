defmodule Runroller.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_args \\ []) do
    children = [
      worker(Runroller.App, []),
      worker(Runroller.Cache, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
