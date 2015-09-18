defmodule Runroller.App do
  def start_link do
    {:ok, pid} = Plug.Adapters.Cowboy.http(
      Runroller.Router,
      [],
      port: Runroller.listen_port
    )
    Process.link(pid)
    {:ok, pid}
  end
end
