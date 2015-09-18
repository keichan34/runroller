defmodule Runroller.App do
  def start_link do
    {:ok, pid} = Plug.Adapters.Cowboy.http Runroller.Router, []
    Process.link(pid)
    {:ok, pid}
  end
end
