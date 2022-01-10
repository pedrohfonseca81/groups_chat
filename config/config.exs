# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :groups_chat,
  ecto_repos: [GroupsChat.Repo]

# Configures the endpoint
config :groups_chat, GroupsChatWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dTBSV8WNCYmxfWA8WjAbYnGuMHqjBBVEChdsaB7XsgfW1S2R2kYpbYqqa3IRuuaV",
  render_errors: [view: GroupsChatWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: GroupsChat.PubSub,
  live_view: [signing_salt: "fu4CVSxv"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
