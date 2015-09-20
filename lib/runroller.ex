defmodule Runroller do
  use Application

  def start(_type, _args) do
    Runroller.Supervisor.start_link
  end

  def listen_port do
    Application.get_env __MODULE__, :port
  end

  def query_adapter, do: Application.get_env(__MODULE__, :query_adapter)
end
