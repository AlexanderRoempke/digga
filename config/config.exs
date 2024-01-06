# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :digga, Digga.Repo,
  migration_primary_key: [name: :id, type: :binary_id],
  types: Digga.PostgrexTypes

config :digga, :env, Mix.env()

config :digga,
  ecto_repos: [Digga.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

config :saas_kit,
  api_key: "K_BQbPQlbvK7RaJaicnLlH478xkkLiq4-aT_nygX" 
  
# Configures the endpoint
config :digga, DiggaWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [html: DiggaWeb.ErrorHTML, json: DiggaWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Digga.PubSub,
  live_view: [signing_salt: "kKjEGQj5"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :digga, Digga.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# This implements Ueberauth with the Github Strategy.
# There are other strategies like Twitter, Google, Apple and Facebook.
# Read more in the Ueberauth docs.
config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user:email"]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID") || "c88d7ae6b8043669b48d",
  client_secret: System.get_env("GITHUB_CLIENT_SECRET") || "7127f3ea83d5d6d65d4767e721030c07d1ee212c"


config :digga, Digga.Users.Guardian,
  issuer: "digga",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY_ADMINS") || "atua8ZYa2gkBmD094l85zx1nAyvtXWGXoUk4x3gU8gAoRTe63OpvO5M2p3Q+lIFz"


config :digga, Digga.Admins.Guardian,
  issuer: "digga",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY_ADMINS") || "UcioUfdnnd/LPwEeJjvyPOjsCGNneqdL3upt0/wL2K3oZynzIzZIEEC/VvY0mY/g"


config :digga, Oban,
  repo: Digga.Repo,
  queues: [default: 10, mailers: 20, high: 50, low: 5],
  plugins: [
    {Oban.Plugins.Pruner, max_age: (3600 * 24)},
    {Oban.Plugins.Cron,
      crontab: [
        {"0 8 * * *", Digga.DailyReports.DailyReportWorker},
        {"0 9 * * *", Digga.Campaigns.ExecuteStepWorker},
        {"@reboot", Digga.OneOffs.RunOneOffsWorker},
       # {"0 2 * * *", Digga.Workers.DailyDigestWorker},
       # {"@reboot", Digga.Workers.StripeSyncWorker},
        {"0 2 * * *", Digga.DailyReports.DailyReportWorker},
     ]}
  ]

config :flop, repo: Digga.Repo

config :digga,
  open_ai_api_key: System.get_env("OPEN_AI_KEY") || "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"

config :waffle,
  storage: Waffle.Storage.S3, # or Waffle.Storage.Local
  bucket: System.get_env("AWS_BUCKET") # if using S3

config :ex_aws,
  json_codec: Jason,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_REGION")

config :digga, onboarding_required: true

config :digga, require_2fa_setup: true


config :fun_with_flags, :persistence,
  adapter: FunWithFlags.Store.Persistent.Ecto,
  repo: Digga.Repo

config :fun_with_flags, :cache_bust_notifications,
  enabled: true,
  adapter: FunWithFlags.Notifications.PhoenixPubSub,
  client: Digga.PubSub

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
