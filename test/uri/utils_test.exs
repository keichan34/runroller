defmodule Runroller.URI.UtilsTest do
  use ExUnit.Case, async: true

  import Runroller.URI.Utils, only: [normalize_uri: 1]

  test "normalize_uri correctly normalizes a bare domain" do
    assert normalize_uri("elixir-lang.org") == "http://elixir-lang.org/"
  end

  test "normalize_uri adds HTTP to a protocol-less URI" do
    assert  normalize_uri("//elixir-lang.org/with-a-path/?and-query=true#hash")
            ==
            "http://elixir-lang.org/with-a-path/?and-query=true#hash"
  end

  test "normalize_uri adds a path if there is none" do
    assert normalize_uri("https://elixir-lang.org") == "https://elixir-lang.org/"
  end

  test "normalize_uri doesn't touch a HTTPS URI" do
    assert normalize_uri("https://elixir-lang.org/") == "https://elixir-lang.org/"
  end
end
