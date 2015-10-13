use Mix.Config

config :runroller,
  port: 4000,
  query_adapter: Runroller.Query.HTTPoisonAdapter

# config :runroller,
#   https: [
#     port: 4001,
#     certfile: "priv/ssl/cert.pem",
#     keyfile: "priv/ssl/key.pem"
#   ]
