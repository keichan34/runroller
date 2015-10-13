defmodule Runroller.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_args \\ []) do
    children = [
      supervisor(Runroller.AppSupervisor, []),
      worker(Runroller.Cache, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
