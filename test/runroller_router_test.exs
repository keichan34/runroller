defmodule RunrollerRouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts Runroller.Router.init([])

  test "index" do
    # Create a test connection
    conn = conn(:get, "/")

    # Invoke the plug
    conn = Runroller.Router.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "{\"info\":\"Runroller is an API to unroll HTTP redirects.\",\"contact\":{\"adn\":\"keita\",\"twitter\":\"sleepy_keita\"}}"
  end
end
