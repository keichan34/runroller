defmodule Runroller.AppSupervisor do
  use Supervisor

  alias Runroller.App

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_args \\ []) do
    children = [
      worker(App, options_for(:http), id: :runroller_app_http)
    ]

    if Runroller.https? do
      children = [
        worker(App, options_for(:https), id: :runroller_app_https)
      | children]
    end

    supervise(children, strategy: :one_for_one)
  end

  defp options_for(:http) do
    [:http]
  end

  defp options_for(:https) do
    options = Dict.merge(
      [otp_app: :runroller],
      Runroller.https_options)

    [:https, options]
  end
end
