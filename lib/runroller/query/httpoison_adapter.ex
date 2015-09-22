defmodule Runroller.Query.HTTPoisonAdapter do
  @behaviour Runroller.Query

  require Logger

  def head(uri, headers) do
    Logger.info "URI=#{uri} ; Start HEAD"
    case HTTPoison.head(uri, headers) do
      {:ok, %HTTPoison.Response{} = resp} ->
        headers = resp.headers
        |> Enum.map(fn({k, v}) -> {String.downcase(k), v} end)
        |> Enum.into(%{})

        Logger.info "URI=#{uri} ; Received #{resp.status_code}"

        {:ok, resp.status_code, headers}
      {:error, error} ->
        Logger.info "URI=#{uri} ; Error: #{error.reason}"
        {:error, error.reason}
    end
  end
end
