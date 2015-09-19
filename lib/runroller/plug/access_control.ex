defmodule Runroller.Plug.AccessControl do
  @behaviour Plug

  alias Plug.Conn
  import Plug.Conn #, only: [put_resp_header: 3, put_status: 2, halt: 1]

  def init([]), do: []
  def call(%Conn{method: "OPTIONS"} = conn, []) do
    conn
    |> put_cors_headers
    |> send_resp(200, "")
    |> halt
  end
  def call(conn, []) do
    conn
    |> put_cors_headers
  end

  defp put_cors_headers(conn) do
    conn
    |> put_resp_header("access-control-allow-origin", "*")
    |> put_resp_header("access-control-max-age", "1728000") # 20 days
    |> put_resp_header("access-control-allow-methods", "GET, OPTIONS")
  end
end
