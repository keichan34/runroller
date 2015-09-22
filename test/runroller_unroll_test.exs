defmodule RunrollerUnrollTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts Runroller.Router.init([])

  def unroll(uri) do
    query = URI.encode_query(%{"uri" => uri})
    conn = conn(:get, "/unroll?#{query}")
    |> Runroller.Router.call(@opts)

    {:ok, body} = Poison.decode(conn.resp_body)
    {conn.status, body}
  end

  def assert_unrolled({status, body}, uri \\ "http://www.example.com/200") do
    assert status == 200
    assert body["unrolled_uri"] == uri
  end

  test "a URI with no redirects" do
    assert_unrolled unroll("http://www.example.com/200")
  end

  test "a URI with one redirect" do
    assert_unrolled unroll("http://www.example.com/one_to_200")
  end

  test "a URI with two redirects" do
    assert_unrolled unroll("http://www.example.com/two_to_200")
  end

  test "a URI with one 301 redirect" do
    assert_unrolled unroll("http://www.example.com/one_301_to_200")
  end

  test "a URI with a relative Location: header" do
    assert_unrolled unroll("http://www.example.com/302_to_relative")
  end
end
