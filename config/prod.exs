use Mix.Config

# Use the following to enable HTTPS:
# config :runroller,
#   port: 4000,
#   https: [
#     port: 4001,
#     certfile: "priv/ssl/cert.pem",
#     keyfile: "priv/ssl/key.pem"
#   ]

config :runroller,
  port: 4000,
  query_adapter: Runroller.Query.HTTPoisonAdapter,
  timeout: 20_000

config :logger,
  backends: [{LoggerFileBackend, :file_log}]

config :logger, :file_log,
  path: "/var/log/runroller/prod.log",
  level: :info

import_config "prod.secret.exs"
