defmodule Runroller do
  use Application

  def start(_type, _args) do
    Runroller.Supervisor.start_link
  end

  def listen_port do
    Application.get_env(:runroller, :port) || 4000
  end

  def https? do
    !!Application.get_env(:runroller, :https)
  end

  def https_options do
    Application.get_env(:runroller, :https, [])
  end

  def query_adapter,
    do: Application.get_env(:runroller, :query_adapter) || Runroller.Query.HTTPoisonAdapter
end
