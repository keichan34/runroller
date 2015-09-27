use Mix.Config

config :runroller,
  port: 4000,
  query_adapter: Runroller.Query.HTTPoisonAdapter

config :logger,
  backends: [{LoggerFileBackend, :file_log}]

config :logger, :file_log,
  path: "/var/log/runroller/prod.log",
  level: :info
