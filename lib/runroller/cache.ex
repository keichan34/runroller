defmodule Runroller.Cache do
  # Keys will expire after 30 minutes.
  @default_expiry 1_800_000

  # Minimum TTL
  @minimum_expiry 60_000

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get(key) do
    Agent.get_and_update(__MODULE__, fn(map) ->
      query_time = :erlang.system_time(:milli_seconds)
      case Map.get(map, key) do
        {value, :infinity} ->
          {{:hit, key, value, :infinity}, map}
        {value, expires_at} when expires_at > query_time ->
          {{:hit, key, value, expires_at}, map}
        {_, _} ->
          # Expired; return nil and remove this from the map.
          {{:miss, key}, Map.delete(map, key)}
        nil ->
          {{:miss, key}, map}
      end
    end)
  end

  @doc """
  Stores the {key, val} in the key-value store. If the key exists, expiry will
  be lengthened to now + `expiry` (default 24 hours)
  """
  def store(key, val, expiry \\ @default_expiry) do
    Agent.update(__MODULE__, fn(map) ->
      query_time = :erlang.system_time(:milli_seconds)

      store_val = if expiry == :infinity do
        {val, :infinity}
      else
        {val, query_time + max(@minimum_expiry, expiry)}
      end

      Map.update(map, key, store_val, fn
        ({_, :infinity}) ->
          store_val
        ({our_val, expires_at}) when our_val == val and expires_at > query_time ->
          store_val
        (other) ->
          other
      end)
    end)
  end

  @doc """
  Wipes the entire cache out.
  """
  def purge do
    Agent.update(__MODULE__, fn(_) -> %{} end)
  end
end
