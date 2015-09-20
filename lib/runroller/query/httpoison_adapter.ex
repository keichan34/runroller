defmodule Runroller.Query.HTTPoisonAdapter do
  @behaviour Runroller.Query

  def head(uri, headers) do
    case HTTPoison.head(uri, headers) do
      {:ok, %HTTPoison.Response{} = resp} ->
        headers = resp.headers
        |> Enum.map(fn({k, v}) -> {String.downcase(k), v} end)
        |> Enum.into(%{})

        {:ok, resp.status_code, headers}
      {:error, error} ->
        {:error, error.reason}
    end
  end
end
