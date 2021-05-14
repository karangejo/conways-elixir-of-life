use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :conway_phx, ConwayPhx.Endpoint,
  http: [port: 4002],
  server: false
