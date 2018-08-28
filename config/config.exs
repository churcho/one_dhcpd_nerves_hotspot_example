# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.
config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.
config :shoehorn,
  init: [:nerves_runtime, :nerves_init_gadget],
  app: Mix.Project.config()[:app]

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.
config :logger, :console,
  backends: [RingLogger],
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Authorize the device to receive firmware using your public key.
# See https://hexdocs.pm/nerves_firmware_ssh/readme.html for more information
# on configuring nerves_firmware_ssh.

key = Path.join(System.user_home!, ".ssh/id_rsa.pub")
unless File.exists?(key), do:
  Mix.raise("No SSH Keys found. Please generate an ssh key")

config :nerves_firmware_ssh,
  authorized_keys: [
    File.read!(key)
  ]

# Configure nerves_init_gadget.
# See https://hexdocs.pm/nerves_init_gadget/readme.html for more information.

config :nerves_init_gadget,
  ifname: "usb0",
  address_method: :dhcpd,
  mdns_domain: "nerves.local",
  node_name: :hello_hotspot,
  node_host: :mdns_domain,
  ssh_console_port: 22

# Configures the endpoint
if Mix.Project.config()[:target] == "host" do
  config :hello_hotspot, HelloHotspotWeb.Endpoint,
    url: [host: "localhost"],
    secret_key_base: "BhoAjQvw9/2A4M9xZ0Wp6vsJzCNqqPElutSc5ni2ZAxyU85/GqtlWLbvBfdnZDK1",
    render_errors: [view: HelloHotspotWeb.ErrorView, accepts: ~w(html json)],
    pubsub: [name: HelloHotspot.PubSub,
    adapter: Phoenix.PubSub.PG2]
else
  config :hello_hotspot, HelloHotspotWeb.Endpoint,
    url: [host: "nerves.local"],
    secret_key_base: "BhoAjQvw9/2A4M9xZ0Wp6vsJzCNqqPElutSc5ni2ZAxyU85/GqtlWLbvBfdnZDK1",
    render_errors: [view: HelloHotspotWeb.ErrorView, accepts: ~w(html json)],
    pubsub: [name: HelloHotspot.PubSub,
    adapter: Phoenix.PubSub.PG2]
end

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
