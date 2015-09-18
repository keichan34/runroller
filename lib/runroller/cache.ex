defmodule Runroller.Cache do
  # Keys will expire after 30 minutes.
  @default_expiry 1_800_000

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get(key) do
    Agent.get_and_update(__MODULE__, fn(map) ->
      query_time = :erlang.system_time(:milli_seconds)
      case Map.get(map, key) do
        {value, expires_at} when expires_at > query_time ->
          {value, map}
        {_, _} ->
          # Expired; return nil and remove this from the map.
          {nil, Map.delete(map, key)}
        nil ->
          {nil, map}
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
      store_val = {val, query_time + expiry}
      Map.update(map, key, store_val, fn
        ({our_val, expires_at}) when our_val == val and expires_at > query_time ->
          store_val
        (other) ->
          other
      end)
    end)
  end
end
