defmodule Runroller.Router do
  use Plug.Router

  plug Plug.Logger
  plug Runroller.Plug.AccessControl
  plug :match
  plug :dispatch

  get "/" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200,
      "{\"info\":\"Runroller is an API to unroll HTTP redirects.\",\"contact\":{\"adn\":\"keita\",\"twitter\":\"sleepy_keita\"}}")
  end

  get "/unroll" do
    query = URI.decode_query(conn.query_string)
    uri = String.strip(query["uri"])

    case Runroller.Query.lookup(uri) do
      {:ok, unrolled_uri} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Poison.encode!(%{error: false, uri: uri, unrolled_uri: unrolled_uri}))
      {:error, reason} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(Runroller.Errors.code_for(reason), Poison.encode!(%{
          error: true,
          uri: uri,
          error_code: reason,
          error_description: Runroller.Errors.description_for(reason)
        }))
    end
  end

  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, "{\"error\":true,\"error_description\":\"That endpoint does not exist, or it hasn't been implemented yet.\"}")
  end
end
