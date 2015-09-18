defmodule Runroller.Query do
  @lookup_timeout 8000

  def lookup(uri) do
    flush
    {pid, ref} = spawn_monitor(__MODULE__, :lookup, [self, uri])
    receive do
      {:DOWN, ^ref, :process, ^pid, _reason} ->
        {:error, :crash}
      result -> result
    after
      @lookup_timeout ->
        {:error, :timeout}
    end
  end

  def lookup(from, uri) do
    send from, perform_lookup(uri)
  end

  defp flush do
    receive do
      _ -> flush
    after
      0 -> :ok
    end
  end

  defp perform_lookup(uri),
    do: perform_lookup(uri, 0)
  defp perform_lookup(_, depth) when depth >= 8 do
    {:error, :too_many_redirects}
  end
  defp perform_lookup(uri, depth) do
    Runroller.Cache.get(uri)
    |> perform_head(uri, depth)
  end

  defp perform_head(nil, uri, depth) do
    case HTTPoison.head(uri, default_headers) do
      {:ok, %HTTPoison.Response{status_code: code} = resp} when code >= 300 and code <= 399 ->
        headers = resp.headers
        |> Enum.map(fn({k, v}) -> {String.downcase(k), v} end)
        |> Enum.into(%{})

        destination_uri = Map.get(headers, "location")
        if is_nil(destination_uri) do
          {:error, :missing_location_header_from_response}
        else
          Runroller.Cache.store(uri, destination_uri)
          perform_lookup(destination_uri, depth + 1)
        end
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        Runroller.Cache.store(uri, uri)
        {:ok, uri}
      {:error, error} ->
        {:error, error.reason}
    end
  end
  defp perform_head(cached_uri, _uri, _depth) do
    {:ok, cached_uri}
  end

  defp default_headers,
    do: [{"user-agent", "runroller/0.0.1"}]
end
