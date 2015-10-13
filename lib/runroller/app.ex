defmodule Runroller.App do
  def start_link(fun, options \\ []) do
    options = Dict.merge(
      [port: Runroller.listen_port],
      options
    )
    {:ok, pid} = apply(Plug.Adapters.Cowboy, fun, [
      Runroller.Router,
      [],
      options
    ])
    Process.link(pid)
    {:ok, pid}
  end
end
