defmodule Runroller.Plug.AccessControl do
  @behaviour Plug

  import Plug.Conn, only: [put_resp_header: 3]

  def init([]), do: []
  def call(conn, []) do
    conn
    |> put_resp_header("access-control-allow-origin", "*")
    |> put_resp_header("access-control-max-age", "1728000") # 20 days
    |> put_resp_header("access-control-allow-methods", "GET, OPTIONS")
  end
end
