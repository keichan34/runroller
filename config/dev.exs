use Mix.Config

config :runroller,
  port: 4000,
  query_adapter: Runroller.Query.HTTPoisonAdapter,
  timeout: 5_000

# config :runroller,
#   https: [
#     port: 4001,
#     certfile: "priv/ssl/cert.pem",
#     keyfile: "priv/ssl/key.pem"
#   ]
