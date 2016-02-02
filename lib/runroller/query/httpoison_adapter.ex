defmodule Runroller.Query.HTTPoisonAdapter do
  @behaviour Runroller.Query

  require Logger

  def head(uri, headers) do
    Logger.info "URI=#{uri} ; Start HEAD"
    process_response(uri, HTTPoison.head(uri, headers))
  end

  def get(uri, headers) do
    Logger.info "URI=#{uri} ; Start GET"
    process_response(uri, HTTPoison.get(uri, headers))
  end

  defp process_response(uri, {:ok, %HTTPoison.Response{} = resp}) do
    headers = resp.headers
    |> Enum.map(fn({k, v}) -> {String.downcase(k), v} end)
    |> Enum.into(%{})

    Logger.info "URI=#{uri} ; Received #{resp.status_code}"

    {:ok, resp.status_code, headers}
  end

  defp process_response(uri, {:error, error}) do
    Logger.info "URI=#{uri} ; Error: #{error.reason}"
    {:error, error.reason}
  end
end
