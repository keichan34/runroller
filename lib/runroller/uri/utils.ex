defmodule Runroller.URI.Utils do
  def merge(a, b) do
    Map.merge a, b, fn
      (_k, v1, nil) ->
        v1
      (_k, _v1, v2) ->
        v2
    end
  end

  def normalize_uri(uri) when is_binary(uri) do
    uri
    |> URI.parse
    |> normalize_uri
  end

  def normalize_uri(%URI{authority: nil, host: nil, scheme: nil, path: path} = uri) do
    # a "bare" URI was passed to URI.parse; so we'll move that to authority and host.
    [host | rest] = String.split(path, "/")
    %{uri | host: host,
            authority: host,
            path: "/" <> Enum.join(rest, "/")}
    |> normalize_uri
  end

  def normalize_uri(%URI{path: path} = uri) when is_nil(path) or path == "" do
    %{uri | path: "/"}
    |> normalize_uri
  end

  def normalize_uri(%URI{scheme: nil} = uri) do
    %{uri | scheme: "http"}
    |> normalize_uri
  end

  def normalize_uri(%URI{} = uri), do: URI.to_string(uri)
end
