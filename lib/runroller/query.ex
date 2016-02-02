defmodule Runroller.Query do
  use Behaviour

  @doc "Performs a HEAD request and returns the status code and headers."
  defcallback head(uri :: String.t, headers :: Map.t) :: {:ok, integer, Map.t} | {:error, any}

  @doc "Performs a GET request and returns the status code and headers."
  defcallback get(uri :: String.t, headers :: Map.t) :: {:ok, integer, Map.t} | {:error, any}

  @lookup_timeout 20000

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
    result = uri |> Runroller.URI.Utils.normalize_uri |> perform_lookup
    send from, result
  end

  defp flush do
    receive do
      _ -> flush
    after
      0 -> :ok
    end
  end

  defp perform_lookup(uri),
    do: perform_lookup(uri, [])
  defp perform_lookup(_, redirect_path) when length(redirect_path) >= 8 do
    {:error, :too_many_redirects}
  end
  defp perform_lookup(uri, redirect_path) do
    Runroller.Cache.get(uri)
    |> perform_head(redirect_path)
  end

  defp perform_head({:miss, uri}, redirect_path, method \\ :head) do
    case apply(Runroller.query_adapter, method, [uri, default_headers]) do
      {:ok, code, headers} when code >= 300 and code <= 399 ->
        headers = headers
        |> Map.put_new("location", nil)
        process_redirect(uri, code, headers, [uri | redirect_path])

      {:ok, 200, headers} ->
        ttl = ttl_for_code_and_headers(200, headers)
        Runroller.Cache.store(uri, uri, ttl)
        {:ok, :miss, uri, redirect_path}

      {:ok, 405, _} ->
        perform_head({:miss, uri}, redirect_path, :get)

      {:ok, code, _} when code >= 400 and code <= 599 ->
        {:error, "http_#{code}"}

      {:error, reason} ->
        {:error, reason}
    end
  end
  # The last request of the chain should be exactly the same as the request URI.
  defp perform_head({:hit, uri, cached_uri, _expires_at}, redirect_path, _) when uri == cached_uri do
    {:ok, :hit, cached_uri, redirect_path}
  end
  defp perform_head({:hit, uri, cached_uri, _expires_at}, redirect_path, _) do
    perform_lookup(cached_uri, [uri | redirect_path])
  end

  defp process_server_response()

  defp process_redirect(_uri, _code, %{"location" => nil}, _) do
    {:error, :missing_location_header_from_response}
  end
  defp process_redirect(uri, code, %{"location" => location} = headers, redirect_path) do
    location = Runroller.URI.Utils.merge(
      URI.parse(uri),
      URI.parse(location)
    ) |> to_string
    Runroller.Cache.store(uri, location, ttl_for_code_and_headers(code, headers))
    perform_lookup(location, redirect_path)
  end

  # Always return :infinity for a 301 redirect.
  defp ttl_for_code_and_headers(301, _headers) do
    :infinity
  end
  defp ttl_for_code_and_headers(_, %{"expires" => expires}) do
    case Timex.DateFormat.parse(expires, "{RFC1123}") do
      {:ok, datetime} ->
        # Convert the difference in to milliseconds, and set a lower limit to the TTL
        max(
          Timex.Date.diff(datetime, Timex.Date.now, :secs) * 1_000,
          0
        )
      {:error, _} ->
        0
    end
  end
  defp ttl_for_code_and_headers(_, %{"cache-control" => cache_control}) do
    case Regex.run(~r/max-age=(\d+)/, cache_control) do
      nil ->
        0 # Minimum TTL
      [_, seconds] ->
        String.to_integer(seconds) * 1_000
      _ ->
        0
    end
  end

  # The default timeout for a 200 response is 1 hour
  defp ttl_for_code_and_headers(200, _), do: 3_600_000
  defp ttl_for_code_and_headers(_, _), do: 0

  defp default_headers,
    do: [{"user-agent", "runroller/0.0.1"}]
end
